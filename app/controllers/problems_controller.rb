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
    url = 'https://paiza.jp/challenges/ranks/d/info'

    # ランクの昇順、同じランクは難易度の昇順にソートする
    @problems = Problem.order(:rank, :difficulty)
  end

  def filter
    ranks = ['D', 'C', 'B', 'A', 'S']
    rank_min = params[:rank_min].to_i
    rank_max = params[:rank_max].to_i

    difficulty_min = params[:difficulty_min].to_i
    difficulty_max = params[:difficulty_max].to_i

    hide_solved = params[:hide_solved] == '1'

    # ActiveRecord Relationは演算が行われるときに配列を返す
    # SQLクエリを作るための情報が@values、オブジェクトの配列が@recordsにある
    # 参考: https://doruby.jp/users/whale/entries/ActiveRecord--Relation%E3%81%A8%E3%81%AF%E4%B8%80%E4%BD%93%E3%81%AA%E3%82%93%E3%81%AA%E3%81%AE%E3%81%8B

    # 指定したランクのものだけを選ぶ
    @problems = []
    (rank_min..rank_max).each do |i|
      # rubyは配列の連結が'+'出来るみたいなので、ActiveRecord Relationが配列に変換してから足されている(はず)
      @problems += Problem.where(rank: ranks[i])
    end

    # 指定した難易度のものだけを選ぶ
    @problems = @problems.filter { |problem|
      difficulty_min <= problem.difficulty && problem.difficulty <= difficulty_max
    }

    # has_manyで取り出したものは、ActiveRecord::Associations::CollectionProxy
    # 怖いのでto_a(recordsも可)で中身の配列を取り出して操作してみる(中身が空のときは[]が返る)
    solved_problems = []
    solved_problems = current_user.solved_problems.to_a if user_signed_in?

    if hide_solved
      @problems = @problems.filter { |problem|
        !solved_problems.include?(problem)
      }
    end

    render :index
  end

  private

  def problem_params
    params.require(:problem).permit(:rank, :number, :name, :url, :difficulty)
  end
end
