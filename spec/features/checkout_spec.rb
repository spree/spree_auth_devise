require 'spec_helper'

describe "Checkout", :js => true do
  let!(:country) { create(:country, :name => "United States",:states_required => true) }
  let!(:state) { create(:state, :name => "Maryland", :country => country) }
  let!(:shipping_method) do
    shipping_method = create(:shipping_method)
    calculator = Spree::Calculator::Shipping::PerItem.create!(:calculable => shipping_method, :preferred_amount => 10)
    shipping_method.calculator = calculator
    shipping_method.tap(&:save)
  end

  let!(:zone) { create(:zone) }
  let!(:address) { create(:address, :state => state, :country => country) }

  before do
    @product = create(:product, :name => "RoR Mug")
    @product.master.stock_items.first.update_column(:count_on_hand, 1)

    ActionMailer::Base.default_url_options[:host] = "http://example.com"
    Spree::Config[:enable_mail_delivery] = true

    visit spree.root_path
  end

  context "without payment being required" do
    before do
      # So that we don't have to setup payment methods just for the sake of it
      Spree::Order.any_instance.stub :has_available_payment => true
      Spree::Order.any_instance.stub :payment_required? => false
    end

    it "should allow a visitor to checkout as guest, without registration" do
      Spree::Auth::Config.set(:registration_step => true)
      click_link "RoR Mug"
      click_button "Add To Cart"
      within('h1') { page.should have_content("Shopping Cart") }
      click_button "Checkout"

      within('#guest_checkout') { fill_in "Email", :with => "spree@test.com" }
      click_button "Continue"

      str_addr = "bill_address"
      select "United States", :from => "order_#{str_addr}_attributes_country_id"
      ['firstname', 'lastname', 'address1', 'city', 'zipcode', 'phone'].each do |field|
        fill_in "order_#{str_addr}_attributes_#{field}", :with => "#{address.send(field)}"
      end
      select "#{address.state.name}", :from => "order_#{str_addr}_attributes_state_id"

      check "order_use_billing"
      click_button "Save and Continue"
      click_button "Save and Continue"
      page.should have_content("Your order has been processed successfully")
    end

    it "should associate an uncompleted guest order with user after logging in" do
      user = create(:user, :email => "email@person.com", :password => "password", :password_confirmation => "password")
      click_link "RoR Mug"
      click_button "Add To Cart"

      visit spree.login_path
      fill_in "Email", :with => user.email
      fill_in "Password", :with => user.password
      click_button "Login"

      click_link "Cart"
      page.should have_content("RoR Mug")
      within('h1') { page.should have_content("Shopping Cart") }

      click_button "Checkout"
      str_addr = "bill_address"
      select "United States", :from => "order_#{str_addr}_attributes_country_id"
      ['firstname', 'lastname', 'address1', 'city', 'zipcode', 'phone'].each do |field|
        fill_in "order_#{str_addr}_attributes_#{field}", :with => "#{address.send(field)}"
      end
      select "#{address.state.name}", :from => "order_#{str_addr}_attributes_state_id"
      check "order_use_billing"
      click_button "Save and Continue"
      click_button "Save and Continue"
      page.should have_content("Your order has been processed successfully")

      Spree::Order.first.user.should == user
    end

    # Regression test for #890
    it "should associate an incomplete guest order with user after successful password reset" do
      user = create(:user, :email => "email@person.com", :password => "password", :password_confirmation => "password")
      click_link "RoR Mug"
      click_button "Add To Cart"

      visit spree.login_path
      click_link "Forgot Password?"
      fill_in "spree_user_email", :with => "email@person.com"
      click_button "Reset my password"

      # Need to do this now because the token stored in the DB is the encrypted version
      # The 'plain-text' version is sent in the email and there's one way to get that!
      reset_password_email = ActionMailer::Base.deliveries.first
      token_url_regex = /^http:\/\/example.com\/user\/spree_user\/password\/edit\?reset_password_token=(.*)$/
      token = token_url_regex.match(reset_password_email.body.to_s)[1]

      visit spree.edit_spree_user_password_path(:reset_password_token => token)
      fill_in "Password", :with => "password"
      fill_in "Password Confirmation", :with => "password"
      click_button "Update"

      click_link "Cart"
      click_button "Checkout"
      str_addr = "bill_address"
      select "United States", :from => "order_#{str_addr}_attributes_country_id"
      ['firstname', 'lastname', 'address1', 'city', 'zipcode', 'phone'].each do |field|
        fill_in "order_#{str_addr}_attributes_#{field}", :with => "#{address.send(field)}"
      end
      select "#{address.state.name}", :from => "order_#{str_addr}_attributes_state_id"
      check "order_use_billing"
      click_button "Save and Continue"
      page.should_not have_content("Email is invalid")
    end

    it "should allow a user to register during checkout" do
      click_link "RoR Mug"
      click_button "Add To Cart"
      click_button "Checkout"
      page.should have_content("Registration")
      click_link "Create a new account"

      fill_in "Email", :with => "email@person.com"
      fill_in "Password", :with => "spree123"
      fill_in "Password Confirmation", :with => "spree123"
      click_button "Create"
      page.should have_content("You have signed up successfully.")

      str_addr = "bill_address"
      select "United States", :from => "order_#{str_addr}_attributes_country_id"
      ['firstname', 'lastname', 'address1', 'city', 'zipcode', 'phone'].each do |field|
        fill_in "order_#{str_addr}_attributes_#{field}", :with => "#{address.send(field)}"
      end
      select "#{address.state.name}", :from => "order_#{str_addr}_attributes_state_id"
      check "order_use_billing"
      click_button "Save and Continue"
      click_button "Save and Continue"
      page.should have_content("Your order has been processed successfully")

      Spree::Order.first.user.should == Spree::User.find_by_email("email@person.com")
    end
  end
end
