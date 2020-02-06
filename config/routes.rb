Rails.application.routes.draw do
  devise_for :users,  path: 'api/v1/users/',
                      defaults: { format: :json },
                      controllers: {
                        registrations: 'api/v1/registrations',
                        sessions: 'api/v1/sessions'
                      }

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
    end

    match '*all', controller: 'api', action: 'cors_preflight_check', via: :options
  end
end
