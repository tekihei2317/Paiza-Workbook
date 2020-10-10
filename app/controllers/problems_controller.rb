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

    # ランクの昇順、同じランクは番号の昇順にソートする
    @problems = Problem.order(:rank, :number)
  end

  def filter
    # binding.pry
    render json: {
      rank: {
        d: params[:rank_d] == '1',
        c: params[:rank_c] == '1',
        b: params[:rank_b] == '1',
        a: params[:rank_a] == '1',
        s: params[:rank_s] == '1',
      },
      difficulty: {
        min: params[:difficulty_min].to_i,
        max: params[:difficulty_max].to_i,
      },
      hideSolved: params[:hide_solved] == '1',
    }
  end

  private

  def problem_params
    params.require(:problem).permit(:rank, :number, :name, :url, :difficulty)
  end
end
