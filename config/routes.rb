Rails.application.routes.draw do
  devise_for :users

  resources :jobs do
    resources :applications, only: [:create, :destroy]
  end

  root 'jobs#index'
end