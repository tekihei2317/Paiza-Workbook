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
    # binding.pry
    paiza_email = params[:paiza_email]
    paiza_password = params[:paiza_password]
    UpdateSolvedProblemsJob.perform_later(current_user, paiza_email, paiza_password)
    redirect_to root_path
  end

  def recommend
  end
end
