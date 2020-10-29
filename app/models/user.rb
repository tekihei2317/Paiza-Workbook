class User < ApplicationRecord
  has_many :solveds
  has_many :solved_problems, through: :solveds, source: :problem

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable
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
    scraper.visit('https://paiza.jp/student/mypage/results')
    puts "#{self.name}でログインを試みます..."

    # ログインページにリダイレクトされるので、ログインする
    login_to_paiza(scraper.driver, paiza_email, paiza_password)

    # JavaScriptの描画が終わるまで待機する
    wait_javascript_load(scraper.driver)

    # 解答状況を取得して保存する
    solved_problems = scraper.driver.find_element(id: 'tab-results').find_elements(class: 'basicBox')
    must_update_count = solved_problems.count - self.solved_problems.count

    solved_problems.map.with_index do |problem, i|
      # 差分だけ更新する
      break if i >= must_update_count

      # タイトルからランクと問題番号を抜き出す
      title = problem.text.split(/\n/)[0] # C035:試験の合格判定のような形式
      rank = title[/([A-Z])(\d+).+/, 1]
      number = title[/([A-Z])(\d+).+/, 2].to_i

      # スコアを取得する
      regex_for_score = /スコア：[^\d]+(?<score>\d+)点/
      score = problem.text.match(regex_for_score)[:score].to_i

      # ユーザーIDと問題IDのペアをデータベースに保存する
      problem = Problem.find_by(rank: rank, number: number)
      Solved.create(user_id: self.id, problem_id: problem.id, first_score: score) if !problem.nil?
    end

    scraper.driver.quit
    puts '更新が終了しました！'
  end

  private

  def self.dummy_email(auth)
    "#{auth.uid}-#{auth.provider}@example.com"
  end

  def login_to_paiza(driver, paiza_email, paiza_password)
    email_elem = driver.find_element(id: 'email')
    password_elem = driver.find_element(id: 'password')
    submit_btn = driver.find_element(css: 'input[type=submit]')

    email_elem.send_keys(paiza_email)
    password_elem.send_keys(paiza_password)
    submit_btn.click
  end

  def wait_javascript_load(driver)
    wait = Selenium::WebDriver::Wait.new(timeout: 10)
    begin
      wait.until {
        driver.find_element(class: 'basicBox').displayed?
      }
    rescue => exception
      puts "#{self.name}でログインできませんでした"
      return
    else
      puts "#{self.name}でログインしました"
    end
  end
end

class Scraper
  attr_reader :driver

  def initialize
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    options.add_argument('--disable-dev-shm-usage')
    @driver = Selenium::WebDriver.for :chrome, options: options
    puts 'Scraper created.'
  end

  def visit(url)
    @driver.get(url)
  end

  def login(email, password)
    email_elem = driver.find_element(id: 'email')
    password_elem = driver.find_element(id: 'password')
    submit_btn = driver.find_element(css: 'input[type=submit]')

    email_elem.send_keys(email)
    password_elem.send_keys(password)
    submit_btn.click
  end

  def wait_javascript_load()
    wait = Selenium::WebDriver::Wait.new(timeout: 10)
    begin
      wait.until {
        driver.find_element(class: 'basicBox').displayed?
      }
    rescue => exception
      puts "#{self.name}でログインできませんでした"
      return
    else
      puts "#{self.name}でログインしました"
    end
  end
end
