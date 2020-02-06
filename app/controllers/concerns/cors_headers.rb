module CorsHeaders
  extend ActiveSupport::Concern

  included do
    before_action :cors_set_access_control_headers

    def cors_preflight_check
      return unless request.method == 'OPTIONS'

      cors_set_access_control_headers
      render plain: ''
    end
  end

  private

  def cors_set_access_control_headers
    response_headers = response.headers
    response_headers['Access-Control-Allow-Origin'] = '*'
    response_headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, PATCH, DELETE, OPTIONS'
    response_headers['Access-Control-Allow-Headers'] =
      'Origin, Content-Type, Accept, Authorization,'\
      ' Token, Auth-Token, Email, X-User-Token, X-User-Email'
    response_headers['Access-Control-Max-Age'] = '1728000'
  end
end
