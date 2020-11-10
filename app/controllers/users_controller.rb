class UsersController < ApplicationController
  before_action :require_login, only: [:profile, :progress, :update_solved_problems]

  def profile
    @user = current_user
  end

  def progress
    all_challenges = Solved.where(user_id: current_user.id).uniq { |solved| solved.problem.id }
    perfects = Solved.where(user_id: current_user.id, score: 100).uniq { |solved| solved.problem.id }

    @data = Problem.ranks.keys.map do |rank|
      challenged_count = all_challenges.filter { |solved| solved.problem.rank == rank }.count
      perfect_count = perfects.filter { |solved| solved.problem.rank == rank }.count
      not_perfect_count = challenged_count - perfect_count

      perfect = Solved.where(user_id: current_user.id)
      {
        perfect: perfect_count,
        'not perfect': not_perfect_count,
        unchallenged: Problem.where(rank: rank).count - challenged_count,
      }
    end
    @results = Solved.where(user_id: current_user.id).page(params[:page]).per(12)
  end

  def update_solved_problems
    # ログインしている場合はActionCableとJSで処理します
    # ログインしていない場合はログインページにリダイレクトされます
  end

  def recommend
  end
end
