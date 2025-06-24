namespace :api do
  namespace :v1 do
    scope path: :webhooks do
      post 'stripe', to: 'stripe#receive'
    end
  end
end
