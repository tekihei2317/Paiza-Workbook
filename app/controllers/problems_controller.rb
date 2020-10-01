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
    # solved_problemsはActiveRecordと同じように使えるみたい
    solved_problems = current_user&.solved_problems if user_signed_in?
    if hide_solved && !solved_problems.blank? # nil or []
      @problems = @problems.filter { |problem|
        !solved_problems.exists?(id: problem.id)
      }
    end

    render :index
  end

  private

  def problem_params
    params.require(:problem).permit(:rank, :number, :name, :url, :difficulty)
  end
end
