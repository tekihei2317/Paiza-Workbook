class UsersController < ApplicationController
  before_action :require_login, only: [:profile, :progress, :update_solved_problems]

  def profile
    @user = current_user
  end

  def progress
    @data = Problem.ranks.keys.map do |rank|
      {
        '正解' => current_user.solved_problems.where(rank: rank).count,
        '未正解' => Problem.where(rank: rank).count,
      }
    end
  end

  def update_solved_problems
    # ログインしている場合はActionCableとJSで処理します
    # ログインしていない場合はログインページにリダイレクトされます
  end

  def recommend
  end
end
