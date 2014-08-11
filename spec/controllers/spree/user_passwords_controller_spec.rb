RSpec.describe Spree::UserPasswordsController, type: :controller do

  let(:token) { 'some_token' }

  before { @request.env['devise.mapping'] = Devise.mappings[:spree_user] }

  context '#update' do
    context 'when updating password with blank password' do
      it 'shows error flash message, sets spree_user with token and re-displays password edit form' do
        spree_put :update, { spree_user: { password: '', password_confirmation: '', reset_password_token: token } }
        expect(assigns(:spree_user).kind_of?(Spree::User)).to eq true
        expect(assigns(:spree_user).reset_password_token).to eq token
        expect(flash[:error]).to eq I18n.t(:cannot_be_blank, scope: [:devise, :user_passwords, :spree_user])
        expect(response).to render_template :edit
      end
    end
  end
end
