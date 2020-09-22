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
    url = 'https://paiza.jp/challenges/ranks/d'
    @problems = scraping_problems(url)
  end

  private

  def problem_params
    params.require(:problem).permit(:rank, :number, :name, :url, :difficulty)
  end

  def login_to_paiza(driver)
    email_elem = driver.find_element(id: 'email')
    password_elem = driver.find_element(id: 'password')
    submit_btn = driver.find_element(css: 'input[type=submit]')

    email_elem.send_keys('tekihei2317@yahoo.co.jp')
    password_elem.send_keys('tekihei4131752')
    submit_btn.click
  end

  def scraping_problems(url)
    driver = Selenium::WebDriver.for :chrome
    driver.get(url)
    login_to_paiza(driver)

    # problemが取得できないのでスリープしておく(非同期っぽい)
    sleep 1.5

    problems = driver.find_elements(class: 'problem-box')
    res = problems.map do |problem|
      title_elem = problem.find_element(class: 'problem-box__header__title')

      rank, number, name = parse_problem_title(title_elem.text)
      problem_url = title_elem.attribute('href')
      difficulty = problem.find_element(class: 'problem-box__bottom').find_element(css: 'span').text

      Problem.new(rank: rank, number: number, name: name, url: problem_url, difficulty: difficulty)
    end

    driver.quit
    res
  end

  def parse_problem_title(title)
    regex = /(?<rank>[A-D,S])(?<number>\d{3}):(?<name>.*)/
    m = regex.match(title)
    [m[:rank], m[:number].to_i, m[:name]]
  end
end
