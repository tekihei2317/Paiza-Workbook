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
    @problems = scraping_problems(url)
  end

  private

  def problem_params
    params.require(:problem).permit(:rank, :number, :name, :url, :difficulty)
  end

  def scraping_problems(url)
    require 'open-uri'
    charset = nil
    html = open(url) do |f|
      charset = f.charset
      f.read
    end

    doc = Nokogiri::HTML.parse(html, nil, charset)

    nodeset = doc.css('.problem-box')
    nodeset.map do |elem|
      id = elem.attributes['id'].value[/challenge_(\d+)/, 1].to_i
      title = elem.css('.problem-box__header__title').text.chomp
      difficulty = elem.css('.problem-box__bottom > dl > dd:nth-child(10) > b > span').text.to_i

      rank, number, name = parse_problem_title(title)
      Problem.new(
        rank: rank,
        number: number,
        name: name,
        url: make_url_from_id(id),
        difficulty: difficulty,
      )
    end
  end

  def parse_problem_title(title)
    regex = /(?<rank>[A-D,S])(?<number>\d{3}):(?<name>.*)/
    m = regex.match(title)
    [m[:rank], m[:number].to_i, m[:name]]
  end

  def make_url_from_id(id)
    "https://paiza.jp/challenges/#{id}/ready"
  end
end
