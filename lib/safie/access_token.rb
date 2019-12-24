module Safie
  class AccessToken < Rack::OAuth2::AccessToken::Bearer
    undef_required_attributes :client

    def initialize(access_token, attributes = {})
      super attributes.merge(access_token: access_token)
    end

    def token_info!(params = {})
      resource_request do
        get File.join(ISSUER, '/auth/tokeninfo'), params
      end
    end

    def user_info!(params = {})
      token_info = token_info! params
      {
        sub: token_info[:user_id],
        email: token_info[:mail_address]
      }
    end

    private

    def resource_request
      res = yield
      case res.status
      when 200
        JSON.parse(res.body).with_indifferent_access
      when 400
        raise BadRequest.new('API Access Faild', res)
      when 401
        raise Unauthorized.new('Access Token Invalid or Expired', res)
      when 403
        raise Forbidden.new('Insufficient Scope', res)
      else
        raise HttpError.new(res.status, 'Unknown HttpError', res)
      end
    end
  end
end
