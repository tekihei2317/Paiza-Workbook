namespace :scraping do
  def parse_html(url)
    require 'open-uri'
    charset = nil
    html = URI.open(url) do |f|
      charset = f.charset
      f.read
    end
    return Nokogiri::HTML.parse(html, nil, charset)
  end

  desc '問題一覧をデータベースに保存する'
  task :add_problems_to_database => :environment do
    urls = ['d', 'c', 'b', 'a', 's'].map do |rank|
      "https://paiza.jp/challenges/ranks/#{rank}/info"
    end

    urls.each do |url|
      doc = parse_html(url)
      nodeset = doc.css('.problem-box')
      nodeset.map do |elem|
        # "challenge_336"みたいになっているので数字を抜き出す
        id = elem.attributes['id'].value[/challenge_(\d+)/, 1].to_i
        # title='D104:運賃の計算'など
        title = elem.css('.problem-box__header__title').text.chomp
        difficulty = elem.css('.problem-box__bottom > dl > dd:nth-child(10) > b > span').text.to_i

        rank, number, name = Problem.parse_title(title)
        problem = Problem.new(
          rank: rank,
          number: number,
          name: name,
          url: Problem.get_url_from_id(id),
          difficulty: difficulty,
        )
        problem.save
      end
    end
  end

  def login_to_paiza(user, driver)
    email_elem = driver.find_element(id: 'email')
    password_elem = driver.find_element(id: 'password')
    submit_btn = driver.find_element(css: 'input[type=submit]')

    email_elem.send_keys(user.email)
    password_elem.send_keys(user.paiza_password)
    submit_btn.click
  end

  desc 'ユーザーが解いた問題の一覧を取得して、データベースに保存する'
  task :add_solved_information_to_database => :environment do
    options = Selenium::WebDriver::Chrome::Options.new
    # options.add_argument('--headless')
    driver = Selenium::WebDriver.for :chrome, options: options

    # ログイン後、解いた問題が乗っているページに移動する
    driver.get('https://paiza.jp/student/mypage/results')
    user = User.first
    login_to_paiza(user, driver)

    # JavaScriptの描画が終わるまで待機する
    wait = Selenium::WebDriver::Wait.new(timeout: 10)
    wait.until { driver.find_element(class: 'basicBox').displayed? }

    solved_problems = driver.find_element(id: 'tab-results').find_elements(class: 'basicBox')
    solved_problems.map do |problem|
      # タイトルからランクと問題番号を抜き出すする
      title = problem.text.split(/\n/)[0] # C035:試験の合格判定のような形式
      rank = title[/([A-Z])(\d+).+/, 1]
      number = title[/([A-Z])(\d+).+/, 2].to_i

      # 問題IDを見つけて、ユーザーIDとのペアをデータベースに保存する
      problem_id = Problem.find_by(rank: rank, number: number).id
      # binding.pry
      Solved.create(user_id: user.id, problem_id: problem_id)
    end
    driver.quit
  end
end
