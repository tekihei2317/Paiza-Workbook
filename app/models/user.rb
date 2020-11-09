class User < ApplicationRecord
  has_many :solveds
  has_many :solved_problems, through: :solveds, source: :problem

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :omniauthable
  attr_accessor :current_password

  validates :name, presence: true
  validates :email, presence: true

  validates :name, uniqueness: true
  validates :email, uniqueness: true

  def self.find_for_oauth(auth)
    user = User.find_by(uid: auth.uid, provider: auth.provider)

    # binding.pry
    if user.nil?
      user = User.create(
        name: auth.provider == 'twitter' ? auth.info.nickname : auth.info.name,
        uid: auth.uid,
        provider: auth.provider,
        email: auth.info.email.nil? ? User.dummy_email(auth) : auth.info.email,
        password: Devise.friendly_token[0, 20],
      )
    end
    user
  end

  # ユーザーの解答状況を更新する
  def update_solved_problems(paiza_email, paiza_password)
    scraper = Scraper.new
    scraper.update_results(self, paiza_email, paiza_password)
  end

  private

  def self.dummy_email(auth)
    "#{auth.uid}-#{auth.provider}@example.com"
  end
end

class Scraper
  attr_reader :driver

  def initialize
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    options.add_argument('--disable-dev-shm-usage')
    @driver = Selenium::WebDriver.for :chrome, options: options
  end

  def update_results(user, email, password)
    @driver.get('https://paiza.jp/student/mypage/results')

    # ログインページにリダイレクトされるので、ログインする
    Rails.logger.debug "#{user.name}でログインを試みます..."
    login(email, password)

    # JavaScriptの描画が終了後、スクレイピングする
    scrape_first_results(user) if wait_problems_load

    # 再チャレンジ結果をスクレイピングする
    @driver.get('https://paiza.jp/student/mypage/retry-results')
    scrape_retry_results(user) if wait_problems_load

    Rails.logger.debug '更新が終了しました！'
    @driver.quit
  end

  def login(email, password)
    email_elem = driver.find_element(id: 'email')
    password_elem = driver.find_element(id: 'password')
    submit_btn = driver.find_element(css: 'input[type=submit]')

    email_elem.send_keys(email)
    password_elem.send_keys(password)
    submit_btn.click
  end

  def wait_problems_load
    wait = Selenium::WebDriver::Wait.new(timeout: 10)
    problems_loaded = false
    begin
      wait.until {
        driver.find_element(class: 'basicBox').displayed?
      }
    rescue => exception
      Rails.logger.debug 'ログインできませんでした'
    else
      Rails.logger.debug 'ログインに成功しました'
      problems_loaded = true
    end
    problems_loaded
  end

  def scrape_first_results(user)
    first_result_elems = @driver.find_element(id: 'tab-results').find_elements(class: 'basicBox')
    must_update_count = first_result_elems.count - user.solved_problems.count

    binding.pry
    first_result_elems.each.with_index do |result_elem, i|
      # 差分だけ更新する
      break if i >= must_update_count

      rank, number, score = parse_result_text(result_elem.text)

      # データベースに保存する
      problem = Problem.find_by(rank: rank, number: number)
      Solved.create(user_id: user.id, problem_id: problem.id, score: score, first_challenge: true) if !problem.nil?
    end
  end

  def scrape_retry_results(user)
    retry_result_elems = @driver.find_element(id: 'retry_results').find_elements(class: 'basicBox')

    return
    retry_result_elems.each do |result_elem|
      rank, number, score = parse_result_text(result_elem.text)

      # データベースに保存する
      problem = Problem.find_by(rank: rank, number: number)
      Solved.create(user_id: user.id, problem_id: problem.id, score: score, first_challenge: false) if !problem.nil?
    end
  end

  def parse_result_text(text)
    title = text.split(/\n/)[0] # C035:試験の合格判定 など
    rank = title[/([A-Z])(\d+).+/, 1]
    number = title[/([A-Z])(\d+).+/, 2].to_i

    regex_for_score = /スコア：[^\d]+(?<score>\d+)点/
    score = text.match(regex_for_score)[:score].to_i

    regex_for_solved_at = /提出日：(.+)/
    solved_at = text.match(regex_for_solved_at)[1].in_time_zone

    [rank, number, score, solved_at]
  end
end
