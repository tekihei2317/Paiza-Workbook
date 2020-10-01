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

  private

  def problem_params
    params.require(:problem).permit(:rank, :number, :name, :url, :difficulty)
  end
end
