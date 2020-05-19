require 'spec_helper'

describe 'Storefront API v2 Account spec', type: :request do
  describe 'account#create' do
    before { post '/api/v2/storefront/account', params: params }

    context 'valid user params' do
      let(:params) do
        {
          "user": {
            "email": "hello@example.com",
            "password": "password123",
            "password_confirmation": "password123"
          }
        }
      end

      it_behaves_like 'returns 200 HTTP status'

      it 'return JSON API payload of User' do
        expect(JSON.parse(response.body)['data']['attributes']['email']).to eq('hello@example.com')
      end
    end

    context 'invalid user params' do
      let(:params) do
        {
          "user": {
            "email": "hello@example.com",
            "password": "password123",
            "password_confirmation": ""
          }
        }
      end

      it 'return JSON API payload of error' do
        expect(JSON.parse(response.body)['error']).to eq("Password Confirmation doesn't match Password")
      end
    end

  end
end
