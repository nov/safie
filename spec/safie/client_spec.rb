RSpec.describe Safie::Client do
  subject { client }
  let(:client) { Safie::Client.new attributes }
  let(:attributes) { required_attributes }
  let :required_attributes do
    {
      identifier: 'client_id',
      secret: 'client_secret'
    }
  end

  describe 'endpoints' do
    its(:authorization_endpoint) { should == Safie::ENDPOINTS[:authorization] }
    its(:token_endpoint) { should == Safie::ENDPOINTS[:token] }
  end

  describe '#authorization_uri' do
    let(:scope) { nil }
    let(:response_type) { nil }
    let(:query) do
      params = {
        scope: scope,
        response_type: response_type
      }.reject do |k,v|
        v.blank?
      end
      query = URI.parse(client.authorization_uri params).query
      Rack::Utils.parse_query(query).with_indifferent_access
    end

    describe 'scope' do
      subject do
        query[:scope]
      end

      context 'as default' do
        it { should == Safie::DEFAULT_SCOPE.to_s }
      end
    end
  end

  describe '#access_token!' do
    let :access_token do
      client.authorization_code = 'code'
      client.access_token!
    end

    context 'when bearer token is returned' do
      it 'should return Safie::AccessToken' do
        mock_json :post, client.token_endpoint, 'access_token/bearer' do
          access_token.should be_a Safie::AccessToken
        end
      end
    end

    context 'when error is returned' do
      it 'should raise Safie::Client::Error' do
        mock_json :post, client.token_endpoint, 'access_token/invalid_grant', status: 400 do
          expect do
            access_token
          end.to raise_error Safie::Client::Error, 'invalid_request :: Invalid authorization code parameter'
        end
      end
    end
  end
end
