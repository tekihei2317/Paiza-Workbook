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

        # 人数は非ログイン状態では表示されませんでした
        acceptance_rate = elem.css('.problem-box__bottom > dl > dd:nth-child(3)').text.to_f

        average_time = elem.css('.problem-box__bottom > dl > dd:nth-child(5)').text
        average_time_min = average_time[/(\d+)分(\d+)秒/, 1].to_i
        average_time_sec = average_time[/(\d+)分(\d+)秒/, 2].to_i

        average_score = elem.css('.problem-box__bottom > dl > dd:nth-child(7)').text.to_f
        # binding.pry

        rank, number, name = Problem.parse_title(title)
        problem = Problem.new(
          rank: rank,
          number: number,
          name: name,
          url: Problem.get_url_from_id(id),
          difficulty: difficulty,
          acceptance_rate: acceptance_rate,
          average_time_min: average_time_min,
          average_time_sec: average_time_sec,
          average_score: average_score,
        )
        problem.save
      end
    end
    puts '問題一覧を更新しました'
  end
end
