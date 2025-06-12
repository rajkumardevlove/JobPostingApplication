#chat GPT

require 'rails_helper'

RSpec.describe JobsController, type: :controller do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let!(:job) { create(:job) }

  describe 'before_actions' do
    context 'when not authenticated' do
      it 'allows access to index and show' do
        get :index
        expect(response).to have_http_status(:ok)

        get :show, params: { id: job.id }
        expect(response).to have_http_status(:ok)
      end

      it 'redirects to sign_in for new, edit, create, update, destroy' do
        actions = [[:new, {}], [:edit, { id: job.id }], [:create, {}], [:update, { id: job.id }], [:destroy, { id: job.id }]]
        actions.each do |action, params|
          process action, method: action == :create ? :post : (action == :update ? :patch : :delete), params: params
          expect(response).to redirect_to(new_user_session_path)
        end
      end
    end
  end

  describe 'GET #index' do
    it 'assigns current time and jobs' do
      get :index
      expect(assigns(:current_time)).to be_a(String)
      expect(assigns(:jobs)).to match_array([job])
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    before { sign_in(user) }

    it 'initializes the custom service and calls it' do
      service = instance_double('MyCustomService', call: 'result')
      allow(MyCustomService).to receive(:new).and_return(service)

      expect(service).to receive(:call)
      get :show, params: { id: job.id }
      expect(response).to render_template(:show)
    end

    it 'sets @job via before_action' do
      sign_in(user)
      get :show, params: { id: job.id }
      expect(assigns(:job)).to eq(job)
    end
  end

  describe 'GET #new' do
    before { sign_in(user) }

    it 'builds a new job for current_user' do
      get :new
      expect(assigns(:job)).to be_a_new(Job)
      expect(assigns(:job).user).to eq(user)
    end
  end

  describe 'POST #create' do
    before { sign_in(user) }

    context 'with valid params' do
      let(:job_params) { attributes_for(:job) }

      it 'creates a new job and redirects' do
        expect {
          post :create, params: { job: job_params }
        }.to change(user.jobs, :count).by(1)

        expect(response).to redirect_to(Job.last)
        expect(flash[:notice]).to eq('Job was successfully created.')
      end
    end

    context 'with invalid params' do
      let(:invalid_params) { attributes_for(:job, title: nil) }

      it 'does not save and re-renders new' do
        post :create, params: { job: invalid_params }
        expect(assigns(:job).errors).not_to be_empty
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #edit' do
    before { sign_in(user) }

    it 'assigns the requested job' do
      get :edit, params: { id: job.id }
      expect(assigns(:job)).to eq(job)
      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH #update' do
    before { sign_in(user) }

    context 'with valid params' do
      let(:new_title) { 'New Title' }

      it 'updates the job and redirects' do
        patch :update, params: { id: job.id, job: { title: new_title } }
        job.reload
        expect(job.title).to eq(new_title)
        expect(response).to redirect_to(job)
        expect(flash[:notice]).to eq('Job was successfully updated.')
      end
    end

    context 'with invalid params' do
      it 'does not update and re-renders edit' do
        patch :update, params: { id: job.id, job: { title: '' } }
        expect(assigns(:job).errors).not_to be_empty
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    before { sign_in(admin) }

    it 'destroys the job and redirects to index via HTML' do
      expect {
        delete :destroy, params: { id: job.id }, format: :html
      }.to change(Job, :count).by(-1)

      expect(response).to redirect_to(jobs_path)
      expect(flash[:notice]).to eq('Job deleted.')
    end

    it 'responds with turbo_stream format' do
      delete :destroy, params: { id: job.id }, format: :turbo_stream
      expect(response.content_type).to eq('text/vnd.turbo-stream.html')
    end

    it 'forbids non-admin users' do
      sign_in(user)
      delete :destroy, params: { id: job.id }
      expect(response).to redirect_to(jobs_path)
      expect(flash[:alert]).to eq('You are not authorized to perform this action.')
    end
  end
end

#Copilot

# require 'rails_helper'

# RSpec.describe JobsController, type: :controller do
#   let(:user) { instance_double(User, id: 1, admin?: false, jobs: jobs) }
#   let(:admin) { instance_double(User, id: 2, admin?: true, jobs: jobs) }
#   let(:jobs) { class_double(Job) }
#   let(:job) { instance_double(Job, id: 1, title: 'Java', user: user) }
#   let(:valid_attributes) { { title: 'Software Engineer', description: 'Ruby job', company_name: 'Acme', location: 'Remote' } }
#   let(:invalid_attributes) { { title: '' } }
#   let(:service_double) { instance_double(MyCustomService, call: "service result") }

#   before do
#     allow(controller).to receive(:authenticate_user!)
#     allow(controller).to receive(:current_user).and_return(user)
#     allow(Job).to receive(:find).with("1").and_return(job)
#     allow(Job).to receive(:find).with(1).and_return(job)
#     allow(MyCustomService).to receive(:new).and_return(service_double)
#   end

#   describe "GET #index" do
#     before do
#       allow(Job).to receive(:all).and_return([job])
#       get :index
#     end

#     it "returns a success response" do
#       expect(response).to be_successful
#     end

#     it "assigns all jobs as @jobs" do
#       expect(assigns(:jobs)).to eq([job])
#     end

#     it "assigns current time as @current_time" do
#       expect(assigns(:current_time)).not_to be_nil
#       expect(assigns(:current_time)).to be_a(String)
#     end
#   end

#   describe "GET #show" do
#     before do
#       allow(Job).to receive(:find_by).with(title: 'Java').and_return(job)
#       allow(Job).to receive(:first).and_return(job)
#       allow(Job).to receive(:where).and_return([])
#       allow(job).to receive(:class).and_return(Job)
#       allow(Job).to receive(:attribute_types).and_return({"title" => instance_double(ActiveModel::Type::String, serialize: "Java")})
#       allow(MyJob).to receive(:perform_later)
#     end

#     it "returns a success response" do
#       get :show, params: { id: "1" }
#       expect(response).to be_successful
#     end

#     it "assigns the requested job as @job" do
#       get :show, params: { id: "1" }
#       expect(assigns(:job)).to eq(job)
#     end

#     it "uses MyCustomService" do
#       expect(service_double).to receive(:call)
#       get :show, params: { id: "1" }
#     end

#     it "enqueues MyJob" do
#       expect(MyJob).to receive(:perform_later).with('hello')
#       get :show, params: { id: "1" }
#     end
#   end

#   describe "GET #new" do
#     let(:new_job) { instance_double(Job) }

#     before do
#       allow(jobs).to receive(:build).and_return(new_job)
#     end

#     it "returns a success response" do
#       get :new
#       expect(response).to be_successful
#     end

#     it "assigns a new job as @job" do
#       get :new
#       expect(assigns(:job)).to eq(new_job)
#     end
#   end

#   describe "POST #create" do
#     context "with valid params" do
#       let(:new_job) { instance_double(Job, save: true) }
      
#       before do
#         allow(jobs).to receive(:build).with(valid_attributes).and_return(new_job)
#         allow(controller).to receive(:redirect_to).with(new_job, any_args)
#       end
      
#       it "creates a new Job" do
#         expect(jobs).to receive(:build).with(valid_attributes)
#         post :create, params: { job: valid_attributes }
#       end

#       it "redirects to the created job" do
#         post :create, params: { job: valid_attributes }
#         expect(controller).to have_received(:redirect_to).with(new_job, notice: 'Job was successfully created.')
#       end
#     end

#     context "with invalid params" do
#       let(:new_job) { instance_double(Job, save: false) }
      
#       before do
#         allow(jobs).to receive(:build).with(invalid_attributes).and_return(new_job)
#         allow(controller).to receive(:render).with(:new)
#       end
      
#       it "does not create a new job" do
#         post :create, params: { job: invalid_attributes }
#         expect(assigns(:job)).to eq(new_job)
#       end

#       it "renders the 'new' template" do
#         post :create, params: { job: invalid_attributes }
#         expect(controller).to have_received(:render).with(:new)
#       end
#     end
#   end

#   describe "GET #edit" do
#     it "returns a success response" do
#       get :edit, params: { id: "1" }
#       expect(response).to be_successful
#     end
#   end

#   describe "PUT #update" do
#     context "with valid params" do
#       before do
#         allow(job).to receive(:update).with(valid_attributes).and_return(true)
#         allow(controller).to receive(:redirect_to).with(job, any_args)
#       end

#       it "updates the requested job" do
#         expect(job).to receive(:update).with(valid_attributes)
#         put :update, params: { id: "1", job: valid_attributes }
#       end

#       it "redirects to the job" do
#         put :update, params: { id: "1", job: valid_attributes }
#         expect(controller).to have_received(:redirect_to).with(job, notice: 'Job was successfully updated.')
#       end
#     end

#     context "with invalid params" do
#       before do
#         allow(job).to receive(:update).with(invalid_attributes).and_return(false)
#         allow(controller).to receive(:render).with(:edit)
#       end

#       it "renders the 'edit' template" do
#         put :update, params: { id: "1", job: invalid_attributes }
#         expect(controller).to have_received(:render).with(:edit)
#       end
#     end
#   end

#   describe "DELETE #destroy" do
#     before do
#       allow(job).to receive(:destroy)
#     end

#     it "destroys the requested job" do
#       expect(job).to receive(:destroy)
#       delete :destroy, params: { id: "1" }
#     end

#     context "with HTML format" do
#       before do
#         allow(controller).to receive(:redirect_to).with(jobs_path, any_args)
#       end

#       it "redirects to the jobs list" do
#         delete :destroy, params: { id: "1" }
#         expect(controller).to have_received(:redirect_to).with(jobs_path, notice: "Job deleted.")
#       end
#     end

#     context "with turbo_stream format" do
#       it "renders the destroy template" do
#         delete :destroy, params: { id: "1" }, format: :turbo_stream
#         expect(response).to be_successful
#       end
#     end
#   end

#   describe "Authorization" do
#     context "as a non-admin user" do
#       before do
#         allow(controller).to receive(:current_user).and_return(user)
#         allow(controller).to receive(:redirect_to).with(jobs_path, any_args)
#       end

#       it "redirects from new action" do
#         get :new
#         expect(controller).to have_received(:redirect_to).with(jobs_path, alert: "You are not authorized to perform this action.")
#       end

#       it "redirects from create action" do
#         post :create, params: { job: valid_attributes }
#         expect(controller).to have_received(:redirect_to).with(jobs_path, alert: "You are not authorized to perform this action.")
#       end

#       it "redirects from edit action" do
#         get :edit, params: { id: "1" }
#         expect(controller).to have_received(:redirect_to).with(jobs_path, alert: "You are not authorized to perform this action.")
#       end

#       it "redirects from update action" do
#         put :update, params: { id: "1", job: valid_attributes }
#         expect(controller).to have_received(:redirect_to).with(jobs_path, alert: "You are not authorized to perform this action.")
#       end

#       it "redirects from destroy action" do
#         delete :destroy, params: { id: "1" }
#         expect(controller).to have_received(:redirect_to).with(jobs_path, alert: "You are not authorized to perform this action.")
#       end
#     end

#     context "as an admin user" do
#       before do
#         allow(controller).to receive(:current_user).and_return(admin)
#       end

#       it "allows access to new action" do
#         allow(jobs).to receive(:build).and_return(job)
#         get :new
#         expect(response).to be_successful
#       end
#     end
#   end

#   describe "#set_job" do
#     it "finds the job by id" do
#       expect(Job).to receive(:find).with("1").and_return(job)
#       get :show, params: { id: "1" }
#       expect(assigns(:job)).to eq(job)
#     end
#   end

#   describe "#job_params" do
#     it "permits only allowed parameters" do
#       params = ActionController::Parameters.new(job: valid_attributes)
#       allow(controller).to receive(:params).and_return(params)
      
#       # Using send to test private method
#       result = controller.send(:job_params)
      
#       expect(result.to_h).to eq(valid_attributes.stringify_keys)
#     end
#   end
# end