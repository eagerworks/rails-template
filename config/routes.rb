Rails.application.routes.draw do
  devise_for :users,  path: 'api/v1/users/',
                      defaults: { format: :json },
                      controllers: {
                        registrations: 'api/v1/registrations',
                        sessions: 'api/v1/sessions',
                      }
end
