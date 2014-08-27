module Spree
  module Admin
    RSpec.describe OrdersController, type: :controller do
      stub_authorization!

      context '#authorize_admin' do
        it 'grants access to users with an admin role' do
          spree_get :new
          expect(response).to redirect_to spree.cart_admin_order_path(Order.last)
        end
      end
    end
  end
end
