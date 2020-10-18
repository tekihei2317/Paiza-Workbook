class UpdateSolvedProblemsJob < ApplicationJob
  queue_as :default

  def perform(user, paiza_email, paiza_password)
    user.update_solved_problems(paiza_email, paiza_password)
    puts '[LOG] Job ended!'
  end

  after_perform do |job|
    puts 'ジョブが終了したよ！'
  end
end
