RSpec.describe Spree::UsersController, type: :controller do
  let(:admin_user) { create(:user) }
  let(:user) { create(:user) }
  let(:role) { create(:role) }

  before { allow(controller).to receive(:spree_current_user) { user } }

  context '#load_object' do
    it 'redirects to signup path if user is not found' do
      allow(controller).to receive(:spree_current_user) { nil }
      put :update, params: { user: { email: 'foobar@example.com' } }
      expect(response).to redirect_to spree.login_path
    end
  end

  context '#create' do
    it 'creates a new user' do
      post :create, params: { user: { email: 'foobar@example.com', password: 'foobar123', password_confirmation: 'foobar123' } }
      expect(assigns[:user].new_record?).to be false
    end
  end

  context '#update' do
    context 'when updating own account' do
      it 'performs update' do
        put :update, params: { user: { email: 'mynew@email-address.com' } }
        expect(assigns[:user].email).to eq 'mynew@email-address.com'
        expect(response).to redirect_to spree.account_path
      end
    end

    it 'does not update roles' do
      put :update, params: { user: { spree_role_ids: [role.id] }}
      expect(assigns[:user].spree_roles).to_not include role
    end
  end
end
