class ProblemsController < ApplicationController
  def new
    @problem = Problem.new
  end

  def create
    @problem = Problem.new(problem_params)
    if @problem.save
      redirect_to problems_path
    else
      render :new
    end
  end

  def index
    # @problems = Problem.all
    url = 'https://paiza.jp/challenges/ranks/d/info'
    @problems = scraping_all_problems(url)
    @solved_problems = scraping_solved_problems()
  end

  private

  def problem_params
    params.require(:problem).permit(:rank, :number, :name, :url, :difficulty)
  end

  # スクレイピング(Nokogiri<--Seleniumは遅かった)
  def scraping_all_problems(url)
    require 'open-uri'
    charset = nil
    html = open(url) do |f|
      charset = f.charset
      f.read
    end

    doc = Nokogiri::HTML.parse(html, nil, charset)

    nodeset = doc.css('.problem-box')
    nodeset.map do |elem|
      # "challenge_336"みたいになっているので数字を抜き出す
      id = elem.attributes['id'].value[/challenge_(\d+)/, 1].to_i
      title = elem.css('.problem-box__header__title').text.chomp
      difficulty = elem.css('.problem-box__bottom > dl > dd:nth-child(10) > b > span').text.to_i

      rank, number, name = Problem.parse_title(title)
      Problem.new(
        rank: rank,
        number: number,
        name: name,
        url: Problem.get_url_from_id(id),
        difficulty: difficulty,
      )
    end
  end

  # スクレイピング(Selenium<--ログインが必要なので)
  def scraping_solved_problems()
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    driver = Selenium::WebDriver.for :chrome, options: options

    driver.get('https://paiza.jp/student/mypage/results')
    # ログイン画面にリダイレクトされる
    login_to_paiza(driver)

    # JavaScriptの描画が終わるまで待機する
    wait = Selenium::WebDriver::Wait.new(timeout: 10)
    wait.until { driver.find_element(class: 'basicBox').displayed? }

    # 解答済みの問題のランクと問題番号を取得する(ハッシュ形式にする)
    solved_problems = driver.find_element(id: 'tab-results').find_elements(class: 'basicBox')
    res = solved_problems.map do |problem|
      title = problem.text.split(/\n/)[0] # C035:試験の合格判定のような形式
      {
        rank: title[/([A-Z])(\d+).+/, 1],
        number: title[/([A-Z])(\d+).+/, 2].to_i,
      }
    end

    driver.quit
    res
  end

  def login_to_paiza(driver)
    email_elem = driver.find_element(id: 'email')
    password_elem = driver.find_element(id: 'password')
    submit_btn = driver.find_element(css: 'input[type=submit]')

    email_elem.send_keys('tekihei2317@yahoo.co.jp')
    password_elem.send_keys('tekihei4131752')
    submit_btn.click
  end
end
