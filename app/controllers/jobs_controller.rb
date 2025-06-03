# app/controllers/jobs_controller.rb
class JobsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_job, only: [:show, :edit, :update, :destroy]
  before_action :authorize_admin!, except: [:index, :show]

  def index
    @current_time = Time.current.to_s(:db) # 4 => 6.1 - 7.0
    @jobs = Job.all
  end

  def show
    # 52 => 6.1 - 7.0
    # deprecated in Rails 6.1.7+
    date_range = DateTime.now..(DateTime.now + 1.day)
    if date_range.cover?(DateTime.now)
      puts "Date is within the range"
    end

    # 54 => 6.1 - 7.0
    MyJob.perform_later('hello')
    # => The job will NOT be enqueued because before_enqueue throws :abort
    # => The after_enqueue callback will NOT run due to skip_after_callbacks_if_terminated = true
  end

  def new
    @job = current_user.jobs.build
  end

  def create
    @job = current_user.jobs.build(job_params)
    if @job.save
      redirect_to @job, notice: 'Job was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @job.update(job_params)
      redirect_to @job, notice: 'Job was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @job.destroy
    redirect_to jobs_url, notice: 'Job was successfully destroyed.'
  end

  private

  def set_job
    @job = Job.find(params[:id])
  end

  def job_params
    params.require(:job).permit(:title, :description, :company_name, :location)
  end

  def authorize_admin!
    unless current_user&.admin?
      redirect_to jobs_path, alert: "You are not authorized to perform this action."
    end
  end
end
