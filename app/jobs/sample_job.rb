class SampleJob < ApplicationJob
  queue_as :default

  def perform(user, paiza_email, paiza_password)
    # Do something later
    user.update_solved_problems(paiza_email, paiza_password)
    sleep 3
    puts '[LOG] Job ended!'
  end
end
