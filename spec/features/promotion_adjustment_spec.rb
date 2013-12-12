require 'spec_helper'

describe 'promotion adjustments', :js => true do

  let!(:country) { create(:country, :name => "United States",:states_required => true) }
  let!(:state) { create(:state, :name => "Maryland", :country => country) }
  let!(:shipping_method) do
    shipping_method = create(:shipping_method)
    calculator = Spree::Calculator::Shipping::PerItem.create!(:calculable => shipping_method, :preferred_amount => 10)
    shipping_method.calculator = calculator
    shipping_method.save

    shipping_method
  end

  let!(:payment_method) { create(:payment_method) }
  let!(:zone) { create(:zone) }
  let!(:address) { create(:address, :state => state, :country => country) }
  let!(:user) do
    create(:user).tap do |u|
      u.spree_roles << Spree::Role.where(:name => "admin").first_or_create
    end
  end

  before do
    @product = create(:product, :name => "RoR Mug")
    v = @product.variants.create!(sku: 'ROR2')
    v.stock_items.first.update_column(:count_on_hand, 1)

    sign_in_as!(user)
    visit spree.admin_path
    click_link "Promotions"
    click_link "New Promotion"
  end

end
