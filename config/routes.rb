Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users
  resource :account, only: [:show]
  resources :lti, only: [:show, :update]
  post 'lti/start/:id', :to => 'lti#start'
  resources :courses do
    resources :assignments do
      resources :test_reps
    end
  end
end
