require 'spec_helper'

describe 'promotion adjustments', :js => true do

  before(:each) do
    PAYMENT_STATES = Spree::Payment.state_machine.states.keys unless defined? PAYMENT_STATES
    SHIPMENT_STATES = Spree::Shipment.state_machine.states.keys unless defined? SHIPMENT_STATES
    ORDER_STATES = Spree::Order.state_machine.states.keys unless defined? ORDER_STATES
    # creates a default shipping method which is required for checkout
    create(:bogus_payment_method, :environment => 'test')
    # creates a check payment method so we don't need to worry about cc details
    create(:payment_method)

    sm = create(:shipping_method, :zone => Spree::Zone.find_by_name('North America'))
    sm.calculator.set_preference(:amount, 10)

    user = create(:admin_user)
    create(:product, :name => "RoR Mug", :price => "40")
    create(:product, :name => "RoR Bag", :price => "20")

    sign_in_as!(user)
    visit spree.admin_path
    click_link "Promotions"
    click_link "New Promotion"
  end

  # Regression test for #836 (#839 included too)
  context "provides a promotion for the first order for a new user" do
    before do
      fill_in "Name", :with => "Sign up"
      select2 "User signup", :from => "Event Name"
      click_button "Create"
      page.should have_content("Editing Promotion")
      select "First order", :from => "Add rule of type"
      within("#rule_fields") { click_button "Add" }
      select "Create adjustment", :from => "Add action of type"
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
