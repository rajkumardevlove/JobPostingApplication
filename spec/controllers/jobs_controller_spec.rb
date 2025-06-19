require 'rails_helper'

RSpec.describe JobsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user)  { create(:user) }
  let(:admin) { create(:user, :admin) }
  let!(:job)  { create(:job, user: user, title: "Java") }

  describe 'GET #index' do
    it 'returns a success response and assigns jobs' do
      get :index
      expect(response).to be_successful
      expect(assigns(:jobs)).to include(job)
    end

    it 'assigns the formatted current time' do
      fixed_time = Time.zone.parse('2025-01-01 12:34:56')
      allow(Time).to receive(:current).and_return(fixed_time)

      get :index
      expect(assigns(:current_time)).to eq(fixed_time.to_fs(:db))
    end
  end

  describe 'GET #show' do
    it 'returns a success response and calls the custom service' do
      expect(MyCustomService).to receive_message_chain(:new, :call).and_return('Service result')
      get :show, params: { id: job.id }
      expect(response).to be_successful
    end

    context 'when update_attribute! raises ActiveRecord::RecordNotSaved' do
      let(:error_message) { 'something went wrong' }

      before do
        # Stub service and find to return our job double
        allow(MyCustomService).to receive_message_chain(:new, :call).and_return('Service result')
        allow(Job).to receive(:find).and_return(job)
        # Force update_attribute! to raise
        allow(job).to receive(:update_attribute!).with(:title, 'Alice')
          .and_raise(ActiveRecord::RecordNotSaved.new(error_message))
      end

      it 'rescues the exception and prints the failure message' do
        expect {
          get :show, params: { id: job.id }
        }.to output(/Failed to save: #{Regexp.escape(error_message)}/).to_stdout
      end
    end

    context 'when update_attribute! succeeds' do
      before do
        allow(MyCustomService).to receive_message_chain(:new, :call).and_return('Service result')
        allow(Job).to receive(:find).and_return(job)
        allow(job).to receive(:update_attribute!).with(:title, 'Alice').and_return(true)
      end

      it 'does not print a failure message' do
        expect {
          get :show, params: { id: job.id }
        }.not_to output(/Failed to save/).to_stdout
      end
    end
  end

  describe 'GET #new' do
    context 'as authenticated user' do
      before { sign_in user }

      it 'assigns a new job for current_user' do
        get :new
        expect(assigns(:job)).to be_a_new(Job)
        expect(assigns(:job).user).to eq(user)
      end
    end

    context 'as guest' do
      it 'redirects to sign in' do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST #create' do
    let(:valid_params) do
      { job: { title: 'Rails Dev', description: 'Develop stuff', company_name: 'Works Inc.', location: 'Remote' } }
    end

    context 'as authenticated user' do
      before { sign_in user }

      it 'creates a new job' do
        expect { post :create, params: valid_params }.to change(Job, :count).by(1)
        expect(response).to redirect_to(Job.last)
        expect(flash[:notice]).to eq('Job was successfully created.')
      end
    end

    context 'with invalid params' do
      before { sign_in user }

      it 'renders the new template' do
        post :create, params: { job: { title: '' } }
        expect(response).to render_template(:new)
      end
    end

    context 'as guest' do
      it 'redirects to sign in' do
        post :create, params: valid_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET #edit' do
    context 'as admin' do
      before { sign_in admin }

      it 'renders the edit template' do
        get :edit, params: { id: job.id }
        expect(response).to be_successful
      end
    end

    context 'as regular user' do
      before { sign_in user }

      it 'redirects with alert' do
        get :edit, params: { id: job.id }
        expect(response).to redirect_to(jobs_path)
        expect(flash[:alert]).to eq('You are not authorized to perform this action.')
      end
    end
  end

  describe 'PATCH #update' do
    let(:update_params) { { id: job.id, job: { title: 'Updated Title' } } }

    context 'as admin' do
      before { sign_in admin }

      it 'updates the job successfully' do
        patch :update, params: update_params
        expect(response).to redirect_to(job)
        expect(job.reload.title).to eq('Updated Title')
      end

      it 'renders edit on failure' do
        patch :update, params: { id: job.id, job: { title: '' } }
        expect(response).to render_template(:edit)
      end
    end

    context 'as regular user' do
      before { sign_in user }

      it 'does not allow update' do
        patch :update, params: update_params
        expect(response).to redirect_to(jobs_path)
        expect(flash[:alert]).to eq('You are not authorized to perform this action.')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'as admin' do
      before { sign_in admin }

      it 'destroys the job and responds to turbo_stream' do
        expect {
          delete :destroy, params: { id: job.id }, format: :turbo_stream
        }.to change(Job, :count).by(-1)
        expect(response.media_type).to eq('text/vnd.turbo-stream.html')
      end

      it 'redirects in HTML format with notice' do
        delete :destroy, params: { id: job.id }, format: :html
        expect(response).to redirect_to(jobs_path)
        expect(flash[:notice]).to eq('Job deleted.')
      end
    end

    context 'as regular user' do
      before { sign_in user }

      it 'does not allow destroy via HTML' do
        delete :destroy, params: { id: job.id }
        expect(response).to redirect_to(jobs_path)
        expect(Job.exists?(job.id)).to be_truthy
      end

      it 'does not allow destroy via turbo_stream' do
        delete :destroy, params: { id: job.id }, format: :turbo_stream
        expect(response).to redirect_to(jobs_path)
        expect(Job.exists?(job.id)).to be_truthy
      end
    end
  end
end
