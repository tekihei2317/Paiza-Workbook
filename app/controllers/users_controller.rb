class UsersController < ApplicationController
  before_action :require_login, only: [:profile, :progress, :update_solved_problems]

  def profile
    @user = current_user
  end

  def progress
    @data = Problem.ranks.keys.map do |rank|
      correct_count = current_user.solved_problems.where(rank: rank).count
      {
        '正解' => correct_count,
        '未正解' => Problem.where(rank: rank).count - correct_count,
      }
    end
    # @solved_problems = current_user.solved_problems.page(params[:page])
    @solved_problems = Problem.where(rank: 'D').page(params[:page]).per(15)
    # binding.pry
  end

  def update_solved_problems
    # ログインしている場合はActionCableとJSで処理します
    # ログインしていない場合はログインページにリダイレクトされます
  end

  def recommend
  end
end
