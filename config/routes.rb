Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  as :user do
    match '/users/confirmation' => 'confirmations#update', :via => :put, :as => :update_user_confirmation
  end

  devise_for :users, controllers: {confirmations: "confirmations"}
  root :to => "courses#index"
  resource :account, only: [:show]
  resources :lti, only: [:show, :update]
  post 'lti/start/:id', :to => 'lti#start'
  resources :invites
  resources :courses do
    resources :assignments do
      resources :test_reps
      resources :weights, only: [:create, :update, :destroy]
    end
  end
  root :to => "courses#index"
end
