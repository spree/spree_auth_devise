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

  # Regression test for #836 (#839 included too)
  context "provides a promotion for the first order for a new user" do
    before do
      fill_in "Name", :with => "Sign up"
      select2 "User signup", :from => "Event"
      click_button "Create"
      page.should have_content("Editing Promotion")
      select2 "First order", :from => "Add rule of type"
      within("#rule_fields") { click_button "Add" }
      select2 "Create adjustment", :from => "Add action of type"
      within("#actions_container") { click_button "Add" }
      select2 "Flat Percent", :from => "Calculator"
      within(".calculator-fields") { fill_in "Flat Percent", :with => "10" }
      within("#actions_container") { click_button "Update" }

      visit spree.root_path
      click_link "Logout"
    end

    # Regression test for #839
    it "doesn't blow up the signup page" do
      visit "/signup"
      fill_in "Email", :with => "user@example.com"
      fill_in "Password", :with => "Password"
      fill_in "Password Confirmation", :with => "Password"
      click_button "Create"
      # Regression test for #839
      page.should_not have_content("undefined method `user' for nil:NilClass")
    end

    context "with an order" do
      before do
        click_link "RoR Mug"
        click_button "Add To Cart"
      end

      it "correctly applies the adjustment if a user signs up as a real user" do
        visit "/signup"
        fill_in "Email", :with => "user@example.com"
        fill_in "Password", :with => "password"
        fill_in "Password Confirmation", :with => "password"
        click_button "Create"
        visit "/checkout"
        within("#checkout-summary") do
          page.should have_content("Promotion (Sign up)")
        end
      end
    end

    # Covering the registration prior to order case for #836
    context "without an order" do
      it "signing up, then placing an order" do
        visit '/signup'
        fill_in "Email", :with => "user@example.com"
        fill_in "Password", :with => "password"
        fill_in "Password Confirmation", :with => "password"
        click_button "Create"

        click_link "RoR Mug"
        click_button "Add To Cart"

        visit "/checkout"

        within("#checkout-summary") do
          page.should have_content("Promotion (Sign up)")
        end
      end
    end
  end
end
