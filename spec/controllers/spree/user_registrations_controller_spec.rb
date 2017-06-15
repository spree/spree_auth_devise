RSpec.describe Spree::UserRegistrationsController, type: :controller do
  before { @request.env['devise.mapping'] = Devise.mappings[:spree_user] }

  context '#create' do
    before { allow(controller).to receive(:after_sign_up_path_for).and_return(spree.root_path(thing: 7)) }

    it 'redirects to after_sign_up_path_for' do
      spree_post :create, { spree_user: { email: 'foobar@example.com', password: 'foobar123', password_confirmation: 'foobar123' } }
      expect(response).to redirect_to spree.root_path(thing: 7)
    end

    context 'with a guest token present' do
      before do
        request.cookie_jar.signed[:guest_token] = 'ABC'
      end

      it 'assigns orders with the correct token and no user present' do
        order = create(:order, guest_token: 'ABC', user_id: nil, created_by_id: nil)
        spree_post :create, spree_user: { email: 'foobar@example.com', password: 'foobar123', password_confirmation: 'foobar123' }
        user = Spree::User.find_by_email('foobar@example.com')

        order.reload
        expect(order.user_id).to eq user.id
        expect(order.created_by_id).to eq user.id
      end

      it 'does not assign orders with an existing user' do
        order = create(:order, guest_token: 'ABC', user_id: 200)
        spree_post :create, spree_user: { email: 'foobar@example.com', password: 'foobar123', password_confirmation: 'foobar123' }

        expect(order.reload.user_id).to eq 200
      end

      it 'does not assign orders with a different token' do
        order = create(:order, guest_token: 'DEF', user_id: nil, created_by_id: nil)
        spree_post :create, spree_user: { email: 'foobar@example.com', password: 'foobar123', password_confirmation: 'foobar123' }

        expect(order.reload.user_id).to be_nil
      end
    end
  end
end
