require 'rails_helper'

RSpec.describe JobsController, type: :controller do
  describe "GET #index" do
    it "responds successfully" do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it "loads all jobs into @jobs" do
      job = create(:job)
      get :index
      expect(assigns(:jobs)).to include(job)
    end
  end
end