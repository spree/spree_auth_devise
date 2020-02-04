RSpec.describe Spree::UserRegistrationsController, type: :controller do
  before { @request.env['devise.mapping'] = Devise.mappings[:spree_user] }

  context '#create' do
    before { allow(controller).to receive(:after_sign_up_path_for).and_return(spree.account_path) }

    it 'redirects to account_path' do
      post :create, params: { spree_user: { email: 'foobar@example.com', password: 'foobar123', password_confirmation: 'foobar123' } }
      expect(response).to redirect_to spree.account_path
    end

    context 'with a guest token present' do
      before do
        if Spree.version.to_f > 3.6
          request.cookie_jar.signed[:token] = 'ABC'
        else
          request.cookie_jar.signed[:guest_token] = 'ABC'
        end
      end

      it 'assigns orders with the correct token and no user present' do
        if Spree.version.to_f > 3.6
          order = create(:order, token: 'ABC', user_id: nil, created_by_id: nil)
        else
          order = create(:order, guest_token: 'ABC', user_id: nil, created_by_id: nil)
        end
        post :create, params: { spree_user: { email: 'foobar@example.com', password: 'foobar123', password_confirmation: 'foobar123' }}
        user = Spree.user_class.find_by_email('foobar@example.com')

        order.reload
        expect(order.user_id).to eq user.id
        expect(order.created_by_id).to eq user.id
      end

      it 'does not assign orders with an existing user' do
        if Spree.version.to_f > 3.6
          order = create(:order, token: 'ABC', user_id: 200)
        else
          order = create(:order, guest_token: 'ABC', user_id: 200)
        end
        post :create, params: { spree_user: { email: 'foobar@example.com', password: 'foobar123', password_confirmation: 'foobar123' }}

        expect(order.reload.user_id).to eq 200
      end

      it 'does not assign orders with a different token' do
        if Spree.version.to_f > 3.6
          order = create(:order, token: 'DEF', user_id: nil, created_by_id: nil)
        else
          order = create(:order, guest_token: 'DEF', user_id: nil, created_by_id: nil)
        end
        post :create, params: { spree_user: { email: 'foobar@example.com', password: 'foobar123', password_confirmation: 'foobar123' }}

        expect(order.reload.user_id).to be_nil
      end
    end
  end
end
