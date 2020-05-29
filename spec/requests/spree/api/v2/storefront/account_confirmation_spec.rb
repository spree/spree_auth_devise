require 'spec_helper'

describe 'Storefront API v2 Account Confirmation spec', type: :request do
  describe 'account_confirmations#show' do

    before do
      Spree::User.stub(:confirm_by_token, confirmation_token: confirmation_token).and_return user
      get "/api/v2/storefront/account_confirmations/#{confirmation_token}"
    end

    context 'valid confirmation_token param' do
      let(:user) { create(:user, confirmation_token: '12345') }
      let(:confirmation_token) { user.confirmation_token }

      it_behaves_like 'returns 200 HTTP status'

      it 'returns user state' do
        expect(JSON.parse(response.body)['data']['state']).to eq('')
      end
    end

    context 'invalid confirmation_token param' do
      let(:user) do
        user = create(:user)
        user.errors.add(:confirmation_token, :invalid)
        return user
      end
      let(:confirmation_token) { 'dummy_token' }

      it 'return 422 status' do
        expect(response.code).to eq('422')
      end

      it 'return JSON API payload of error' do
        expect(JSON.parse(response.body)['error']).to eq("Confirmation token is invalid")
      end
    end

    context 'blank confirmation_token param' do
      let(:user) { build(:user) }
      let(:confirmation_token) { '' }

      it 'return 301 status' do
        expect(response.code).to eq('301')
      end
    end
  end
end
