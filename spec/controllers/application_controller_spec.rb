require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  # <-- include Devise’s controller helpers
  include Devise::Test::ControllerHelpers

  # use a Devise controller to test the before_action & layout logic
  controller(Devise::RegistrationsController) do
    def new
      render plain: "Devise Controller OK"
    end
  end

  before do
    routes.draw { get 'new' => 'devise/registrations#new' }

    # tell Devise which mapping (:user) to use
    request.env['devise.mapping'] = Devise.mappings[:user]
    # Devise::Test::ControllerHelpers will now inject a fake Warden into request.env['warden']

    # Setup fake User model if not already defined
    class User < ApplicationRecord
      devise :database_authenticatable, :registerable
    end unless defined?(User)
  end

  describe 'GET #new on Devise controller' do
    it 'calls layout_by_resource and configure_permitted_parameters' do
      sanitizer = double('Devise::ParameterSanitizer')
      allow(controller).to receive(:devise_parameter_sanitizer).and_return(sanitizer)

      expect(sanitizer).to receive(:permit).with(:sign_up,        keys: [:role])
      expect(sanitizer).to receive(:permit).with(:account_update, keys: [:role])
      expect(controller).to receive(:devise_controller?).at_least(:once).and_call_original

      get :new
      expect(response.body).to eq("Devise Controller OK")
    end
  end

  describe '#layout_by_resource' do
    it 'returns "devise" for Devise controller' do
      allow(controller).to receive(:devise_controller?).and_return(true)
      expect(controller.send(:layout_by_resource)).to eq 'devise'
    end

    it 'returns "application" for non-Devise controller' do
      allow(controller).to receive(:devise_controller?).and_return(false)
      expect(controller.send(:layout_by_resource)).to eq 'application'
    end
  end
end
