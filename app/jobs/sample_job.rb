class SampleJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    puts 'Hello, world!'

    (0..10 ** 7).each do |i|
      puts "current: #{i}" if i % 10 ** 6 == 0
    end
  end
end
