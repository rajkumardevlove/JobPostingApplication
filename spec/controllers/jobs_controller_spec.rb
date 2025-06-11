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
