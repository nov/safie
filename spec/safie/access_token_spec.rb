RSpec.describe Safie::AccessToken do
  subject { access_token }
  let(:access_token) { Safie::AccessToken.new(bearer_token) }
  let(:bearer_token) { 'bearer_token' }

  its(:access_token) { should == bearer_token }

  context 'when refresh_token is given' do
    let(:access_token) do
      Safie::AccessToken.new(
        bearer_token,
        refresh_token: 'refresh_token'
      )
    end
    let(:refresh_token) { 'refresh_token' }
    its(:refresh_token) { should == refresh_token }
  end

  describe '#token_info!' do
    subject { token_info }

    let(:token_info) do
      mock_json :get, Safie::ENDPOINTS[:token_info], 'token_info/success' do
        access_token.token_info!
      end
    end
    it { should include :expires_in, :mail_address, :scope, :status, :user_id }
    it { should_not include :sub, :email }

    context 'when token invalid' do
      it do
        expect do
          mock_json :get, Safie::ENDPOINTS[:token_info], 'token_info/invalid_token', status: 401 do
            access_token.token_info!
          end
        end.to raise_error Safie::Unauthorized
      end
    end
  end

  describe '#user_info!' do
    subject { user_info }

    let(:user_info) do
      mock_json :get, Safie::ENDPOINTS[:token_info], 'token_info/success' do
        access_token.user_info!
      end
    end
    it { should_not include :expires_in, :mail_address, :scope, :status, :user_id }
    it { should include :sub, :email }
  end
end
