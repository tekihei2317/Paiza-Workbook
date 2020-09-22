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
end
