RSpec.describe Spree::ProductsController, type: :controller do
  let!(:product) { create(:product, available_on: 1.year.from_now) }
  let!(:user) { build_stubbed(:user, spree_api_key: 'fake') }

  subject(:request) { spree_get :show, id: product.to_param }

  before do
    allow(controller).to receive(:before_save_new_order)
    allow(controller).to receive(:spree_current_user) { user }
  end

  it 'allows admins to view non-active products' do
    allow(user).to receive(:has_spree_role?) { true }

    request
    expect(response.status).to eq(200)
  end

  it 'cannot view non-active products' do
    allow(user).to receive(:has_spree_role?) { false }

    # this behaviour was introduced in rails 5.1 & Spree 3.5
    # https://github.com/spree/spree/commit/acf52960f5b9582cdfe01f0cb563766b44aabbd5
    if Spree.version.to_f > 3.4
      expect { request }.to raise_error(ActiveRecord::RecordNotFound)
    else
      request
      expect(response.status).to eq(404)
    end
  end
end
