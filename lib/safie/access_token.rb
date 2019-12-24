module Safie
  class AccessToken < Rack::OAuth2::AccessToken::Bearer
    undef_required_attributes :client

    def initialize(access_token, attributes = {})
      super attributes.merge(access_token: access_token)
    end

    def token_info!
      get File.join(ISSUER, '/auth/tokeninfo')
    end
  end
end
