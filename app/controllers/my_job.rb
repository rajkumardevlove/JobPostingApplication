# app/jobs/my_job.rb
class MyJob < ApplicationJob
  before_enqueue do
    # Condition to abort enqueueing the job
    # For demonstration, always abort
    throw :abort
  end

  after_enqueue do
    puts "This will NOT run if enqueueing was aborted (because of the config)"
  end

  def perform(*args)
    puts "Performing job with args: #{args.inspect}"
  end
end
