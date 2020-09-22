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
    # require 'open-uri'
    # charset = nil
    # html = open(url) do |f|
    # charset = f.charset
    # f.read
    # end
    # doc = Nokogiri::HTML.parse(html, nil, charset)
    #
    # nodeset_titles = doc.css('.problem-box__header__title')
    # nodeset_difficulties = doc.css('.problem-box__bottom > dl > dd:nth-child(10) > b > span')
    #
    # titles = nodeset_titles.map { |node| node.text.chomp }
    # difficulties = nodeset_difficulties.map { |node| node.text.to_i }
    #
    # binding.pry
    #
    # titles.zip(difficulties).map do |title, difficulty|
    # rank, number, name = parse_problem_title(title)
    # Problem.new(rank: rank, number: number, name: name, url: '  #', difficulty: difficulty)
    # end
    driver = Selenium::WebDriver.for :chrome
    driver.get(url)
    login_to_paiza(driver)
    []
  end

  def parse_problem_title(title)
    regex = /(?<rank>[A-D,S])(?<number>\d{3}):(?<name>.*)/
    m = regex.match(title)
    [m[:rank], m[:number].to_i, m[:name]]
  end
end
