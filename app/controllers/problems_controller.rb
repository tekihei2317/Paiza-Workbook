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

    # ランクが低い順、同じランクは難易度の昇順にソートする
    problems_rank_neq_s = Problem.where.not(rank: 'S').order({ rank: :desc }, :difficulty)
    problems_rank_eq_s = Problem.where(rank: 'S').order(:difficulty)
    # ActiveRecord Relationは足し算出来るみたい(Arrayになる)
    @problems = problems_rank_neq_s + problems_rank_eq_s
  end

  def filter
    ranks = ['D', 'C', 'B', 'A', 'S']
    rank_min = params[:rank_min].to_i
    rank_max = params[:rank_max].to_i

    difficulty_min = params[:difficulty_min].to_i
    difficulty_max = params[:difficulty_max].to_i

    hide_solved = params[:hide_solved] == '1'

    # 指定したランクのものだけを選ぶ
    @problems = []
    (rank_min..rank_max).each do |i|
      @problems += Problem.where(rank: ranks[i])
    end

    # 指定した難易度のものだけを選ぶ
    @problems = @problems.filter { |problem|
      difficulty_min <= problem.difficulty && problem.difficulty <= difficulty_max
    }

    # 解いているものを除外する
    # solved_problemsはActiveRecordと同じようにfind_byが使える
    solved_problems = current_user.solved_problems
    # binding.pry
    if hide_solved
      @problems = @problems.filter { |problem|
        solved_problems.find_by(id: problem.id).nil?
      }
    end

    render :index
  end

  private

  def problem_params
    params.require(:problem).permit(:rank, :number, :name, :url, :difficulty)
  end
end
