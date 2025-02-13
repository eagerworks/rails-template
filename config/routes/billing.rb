resources :plans, only: [:index], path: 'pricing'
resources :plans, only: [] do
  resources :subscriptions, only: [:new] do
    post :sessions, on: :collection
  end
end
resources :subscriptions, only: [:index, :update]

namespace :checkout do
  resource :return, only: [:show]
end

resources :payment_methods, module: :subscriptions, only: [:new]
resource :cancel, module: :subscriptions, only: [:show, :destroy]
resource :renewal, module: :subscriptions, only: [:show, :create]
