# app/controllers/applications_controller.rb
class ApplicationsController < ApplicationController
  before_action :authenticate_user!

  def create
    job = Job.find(params[:job_id])
    application = job.applications.new(user: current_user)

    if application.save
      redirect_to job, notice: 'Application submitted successfully.'
    else
      redirect_to job, alert: 'Could not apply for the job.'
    end
  end

  def destroy
    application = current_user.applications.find(params[:id])
    application.destroy
    redirect_to job_path(application.job), notice: 'Application withdrawn.'
  end
end
