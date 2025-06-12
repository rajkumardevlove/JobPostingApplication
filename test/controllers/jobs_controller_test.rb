require "test_helper"

class JobsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get jobs_index_url
    assert_response :success
  end

  test "should get show" do
    get jobs_show_url
    assert_response :success
  end

  test "should get new" do
    get jobs_new_url
    assert_response :success
  end

  test "should get create" do
    get jobs_create_url
    assert_response :success
  end

  test "should get edit" do
    get jobs_edit_url
    assert_response :success
  end

  test "should get update" do
    get jobs_update_url
    assert_response :success
  end

  test "should get destroy" do
    get jobs_destroy_url
    assert_response :success
  end
end
# spec/controllers/jobs_controller_spec.rb
require 'rails_helper'

RSpec.describe JobsController, type: :controller do
  let(:user) { create(:user) }
  let(:admin) { create(:user, admin: true) }
  let(:job) { create(:job) }
  
  # Shared examples for actions requiring authentication
  shared_examples "requires authentication" do
    it "redirects to sign in page if user not logged in" do
      subject
      expect(response).to redirect_to(new_user_session_path)
    end
  end
  
  # Shared examples for actions requiring admin rights
  shared_examples "requires admin rights" do
    it "redirects to jobs path if user is not an admin" do
      sign_in user
      subject
      expect(response).to redirect_to(jobs_path)
      expect(flash[:alert]).to eq("You are not authorized to perform this action.")
    end
  end

  describe "GET #index" do
    before { get :index }
    
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
    
    it "assigns @current_time" do
      expect(assigns(:current_time)).not_to be_nil
      expect(assigns(:current_time)).to be_a(String)
    end
    
    it "assigns all jobs as @jobs" do
      expect(assigns(:jobs)).to eq(Job.all)
    end
    
    it "renders the index template" do
      expect(response).to render_template("index")
    end
  end
  
  describe "GET #show" do
    before do
      allow_any_instance_of(MyCustomService).to receive(:call).and_return("test")
      allow(Job).to receive(:find_by).with(title: 'Java').and_return(job)
      allow(Job).to receive(:first).and_return(job)
      allow(Job).to receive(:find).and_return(job)
      allow(job).to receive(:update_attribute!).and_return(true)
      # Mock any other external services called in the show action
    end
    
    it "returns http success" do
      get :show, params: { id: job.id }
      expect(response).to have_http_status(:success)
    end
    
    it "assigns the requested job as @job" do
      get :show, params: { id: job.id }
      expect(assigns(:job)).to eq(job)
    end
    
    it "initializes and calls MyCustomService" do
      expect_any_instance_of(MyCustomService).to receive(:call)
      get :show, params: { id: job.id }
    end
    
    it "renders the show template" do
      get :show, params: { id: job.id }
      expect(response).to render_template("show")
    end
  end
  
  describe "GET #new" do
    subject { get :new }
    
    it_behaves_like "requires authentication"
    it_behaves_like "requires admin rights"
    
    context "when admin is signed in" do
      before do
        sign_in admin
        allow(admin).to receive(:jobs).and_return(Job)
        allow(Job).to receive(:build).and_return(job)
        get :new
      end
      
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
      
      it "assigns a new job as @job" do
        expect(assigns(:job)).to be_a_new(Job)
      end
      
      it "renders the new template" do
        expect(response).to render_template("new")
      end
    end
  end
  
  describe "POST #create" do
    let(:valid_attributes) { { title: "Developer", description: "Job description", company_name: "Company", location: "Remote" } }
    let(:invalid_attributes) { { title: "", description: "", company_name: "", location: "" } }
    
    subject { post :create, params: { job: valid_attributes } }
    
    it_behaves_like "requires authentication"
    it_behaves_like "requires admin rights"
    
    context "when admin is signed in" do
      before do
        sign_in admin
        allow(admin).to receive(:jobs).and_return(Job)
        allow(Job).to receive(:build).and_return(job)
      end
      
      context "with valid params" do
        before do
          allow(job).to receive(:save).and_return(true)
          post :create, params: { job: valid_attributes }
        end
        
        it "creates a new job" do
          expect(Job).to have_received(:build).with(valid_attributes)
          expect(job).to have_received(:save)
        end
        
        it "redirects to the created job" do
          expect(response).to redirect_to(job)
        end
        
        it "sets a success notice" do
          expect(flash[:notice]).to eq('Job was successfully created.')
        end
      end
      
      context "with invalid params" do
        before do
          allow(job).to receive(:save).and_return(false)
          post :create, params: { job: invalid_attributes }
        end
        
        it "assigns a newly created but unsaved job as @job" do
          expect(assigns(:job)).to eq(job)
        end
        
        it "re-renders the 'new' template" do
          expect(response).to render_template("new")
        end
      end
    end
  end
  
  describe "GET #edit" do
    subject { get :edit, params: { id: job.id } }
    
    it_behaves_like "requires authentication"
    it_behaves_like "requires admin rights"
    
    context "when admin is signed in" do
      before do
        sign_in admin
        allow(Job).to receive(:find).and_return(job)
        get :edit, params: { id: job.id }
      end
      
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
      
      it "assigns the requested job as @job" do
        expect(assigns(:job)).to eq(job)
      end
      
      it "renders the edit template" do
        expect(response).to render_template("edit")
      end
    end
  end
  
  describe "PATCH #update" do
    let(:valid_attributes) { { title: "Updated Developer", description: "Updated description" } }
    let(:invalid_attributes) { { title: "", description: "" } }
    
    subject { patch :update, params: { id: job.id, job: valid_attributes } }
    
    it_behaves_like "requires authentication"
    it_behaves_like "requires admin rights"
    
    context "when admin is signed in" do
      before do
        sign_in admin
        allow(Job).to receive(:find).and_return(job)
      end
      
      context "with valid params" do
        before do
          allow(job).to receive(:update).and_return(true)
          patch :update, params: { id: job.id, job: valid_attributes }
        end
        
        it "updates the requested job" do
          expect(job).to have_received(:update).with(valid_attributes)
        end
        
        it "redirects to the job" do
          expect(response).to redirect_to(job)
        end
        
        it "sets a success notice" do
          expect(flash[:notice]).to eq('Job was successfully updated.')
        end
      end
      
      context "with invalid params" do
        before do
          allow(job).to receive(:update).and_return(false)
          patch :update, params: { id: job.id, job: invalid_attributes }
        end
        
        it "assigns the job as @job" do
          expect(assigns(:job)).to eq(job)
        end
        
        it "re-renders the 'edit' template" do
          expect(response).to render_template("edit")
        end
      end
    end
  end
  
  describe "DELETE #destroy" do
    subject { delete :destroy, params: { id: job.id } }
    
    it_behaves_like "requires authentication"
    it_behaves_like "requires admin rights"
    
    context "when admin is signed in" do
      before do
        sign_in admin
        allow(Job).to receive(:find).and_return(job)
        allow(job).to receive(:destroy)
      end
      
      context "with HTML format" do
        before do
          delete :destroy, params: { id: job.id }, format: :html
        end
        
        it "destroys the requested job" do
          expect(job).to have_received(:destroy)
        end
        
        it "redirects to the jobs list" do
          expect(response).to redirect_to(jobs_path)
        end
        
        it "sets a notice" do
          expect(flash[:notice]).to eq("Job deleted.")
        end
      end
      
      context "with Turbo Stream format" do
        before do
          delete :destroy, params: { id: job.id }, format: :turbo_stream
        end
        
        it "destroys the requested job" do
          expect(job).to have_received(:destroy)
        end
        
        it "renders destroy template" do
          expect(response).to render_template("destroy")
        end
      end
    end
  end

  describe "#authorize_admin!" do
    controller do
      before_action :authorize_admin!
      
      def index
        render plain: "Hello World"
      end
      
      private
      
      def authorize_admin!
        unless current_user&.admin?
          redirect_to jobs_path, alert: "You are not authorized to perform this action."
        end
      end
    end
    
    context "when user is admin" do
      before do
        sign_in admin
        get :index
      end
      
      it "allows access to the action" do
        expect(response.body).to eq("Hello World")
      end
    end
    
    context "when user is not admin" do
      before do
        sign_in user
        get :index
      end
      
      it "redirects to the jobs path" do
        expect(response).to redirect_to(jobs_path)
      end
      
      it "sets an alert message" do
        expect(flash[:alert]).to eq("You are not authorized to perform this action.")
      end
    end
  end
end