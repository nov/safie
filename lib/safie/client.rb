module Safie
  class Client < Rack::OAuth2::Client
    class Error < Rack::OAuth2::Client::Error; end

    def initialize(attributes)
      attributes_with_default = {
        authorization_endpoint: File.join(ISSUER, '/auth/authorize'),
        token_endpoint: File.join(ISSUER, '/auth/token')
      }.merge(attributes)
      super attributes_with_default
    end

    def authorization_uri(params = {})
      params[:scope] ||= DEFAULT_SCOPE
      super
    end

    def access_token!(options = {})
      options[:scope] ||= DEFAULT_SCOPE
      super :body, options
    end

    private

    def handle_success_response(response)
      token_hash = JSON.parse(response.body).with_indifferent_access
      AccessToken.new token_hash.delete(:access_token), token_hash
    end

    def handle_error_response(response)
      error = JSON.parse(response.body).with_indifferent_access
      raise Error.new(response.status, error)
    end
  end
end
