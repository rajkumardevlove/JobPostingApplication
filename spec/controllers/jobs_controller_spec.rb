require 'rails_helper'

RSpec.describe JobsController, type: :controller do
  describe "GET #index" do
    it "responds successfully" do
      get :index
      expect(response).to have_http_status(:ok)
      
      render

      # 8 (Rails 7.0): `rendered` returns a String
      # expect(rendered).to include("Engineer")
      # rails 7.1
      assert_includes rendered.to_s, "Welcome"
    end

    it "loads all jobs into @jobs" do
      job = create(:job)
      get :index
      expect(assigns(:jobs)).to include(job)
    end
  end
end