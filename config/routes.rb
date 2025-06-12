Rails.application.routes.draw do
  resources :friends
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  authenticated :user, lambda(&:admin?) do
    ActiveAdmin.routes(self)
  end

  mount Lookbook::Engine, at: '/lookbook' if Rails.env.development?
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  root to: 'home#index'

  draw :billing

  namespace :accounts do
    resource :password, only: [:edit, :update]
  end

  resources :accounts, only: [:index, :new, :create, :show] do
    patch :switch

    resources :account_invitations,
              path: 'invitations', module: :accounts,
              only: [:new, :create, :edit, :update, :destroy] do
      member do
        post :resend
      end
    end
  end
  resources :account_users, path: 'members', only: [:edit, :update, :destroy]
  resources :account_invitations, path: 'invitations', only: [:show, :update, :destroy]
  resources :impersonations, only: [] do
    delete '/', action: :destroy, on: :collection
  end

  resources :credentials, only: [:index, :new, :create, :destroy, :update]

  resources :two_factor, only: [:new, :create]

  # Render dynamic PWA files from app/views/pwa/*
  # (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
