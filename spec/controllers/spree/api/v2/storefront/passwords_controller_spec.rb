RSpec.describe Spree::Api::V2::Storefront::PasswordsController, type: :controller do
  let(:user) { create(:user) }
  let(:password) { 'new_password' }
  let(:store) { create(:store) }

  describe 'POST create' do
    before { post :create, params: params }

    context 'when the user email has not been specified' do
      let(:params) { { user: { email: '' } } }
      it 'responds with not found status' do
        expect(response.code).to eq('404')
      end
    end

    context 'when the user email not found' do
      let(:params) { { user: { email: 'dummy_email@example.com' } } }
      it 'responds with not found status' do
        expect(response.code).to eq('404')
      end
    end

    context 'when the user email has been specified' do
      let(:params) { { user: { email: user.email } } }
      it_behaves_like 'returns 200 HTTP status'
    end
  end

  describe 'PATCH update' do
    before { patch :update, params: params }

    context 'when updating password with blank password' do
      let(:params) {
        {
          id: user.send_reset_password_instructions(Spree::Store.current),
          user: {
            password: '',
            password_confirmation: ''
          }
        }
      }

      it 'responds with error' do
        expect(response.code).to eq('422')
        expect(JSON.parse(response.body)['error']).to eq("Password can't be blank")
      end
    end

    context 'when updating password with specified password' do
      let(:params) {
        {
          id: user.send_reset_password_instructions(Spree::Store.current),
          user: {
            password: password,
            password_confirmation: password
          }
        }
      }

      it_behaves_like 'returns 200 HTTP status'
    end
  end
end
