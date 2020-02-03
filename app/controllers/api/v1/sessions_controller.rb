module Api
  module V1
    class SessionsController < Devise::SessionsController
      skip_before_action :verify_authenticity_token
      respond_to :json
    end
  end
end
