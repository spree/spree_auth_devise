require 'spec_helper'

describe "Checkout", :js => true do
  let!(:country) { create(:country, :name => "United States",:states_required => true) }
  let!(:state) { create(:state, :name => "Maryland", :country => country) }
  let!(:shipping_method) do
    shipping_method = create(:shipping_method)
    calculator = Spree::Calculator::PerItem.create!({:calculable => shipping_method, :preferred_amount => 10}, :without_protection => true)
    shipping_method.calculator = calculator
    shipping_method.save

    shipping_method
  end

  let!(:payment_method) { create(:payment_method) }
  let!(:zone) { create(:zone) }
  let!(:address) { create(:address, :state => state, :country => country) }

  before do
    @product = create(:product, :name => "RoR Mug")
    @product.on_hand = 1
    @product.save

    visit spree.root_path
  end

  it "should allow a visitor to checkout as guest, without registration" do
    Spree::Auth::Config.set(:registration_step => true)
    click_link "RoR Mug"
    click_button "Add To Cart"
    within('h1') { page.should have_content("Shopping Cart") }
    click_button "Checkout"
    page.should have_content("Checkout as a Guest")

    within('#guest_checkout') { fill_in "Email", :with => "spree@test.com" }
    click_button "Continue"
    page.should have_content("Billing Address")
    page.should have_content("Shipping Address")

    str_addr = "bill_address"
    select "United States", :from => "order_#{str_addr}_attributes_country_id"
    ['firstname', 'lastname', 'address1', 'city', 'zipcode', 'phone'].each do |field|
      fill_in "order_#{str_addr}_attributes_#{field}", :with => "#{address.send(field)}"
    end
    select "#{address.state.name}", :from => "order_#{str_addr}_attributes_state_id"
    check "order_use_billing"
    click_button "Save and Continue"
    click_button "Save and Continue"
    click_button "Save and Continue"
    page.should have_content("Your order has been processed successfully")
  end

  it "should associate an uncompleted guest order with user after logging in" do
    user = create(:user, :email => "email@person.com", :password => "password", :password_confirmation => "password")
    click_link "RoR Mug"
    click_button "Add To Cart"

    visit spree.login_path
    fill_in "user_email", :with => user.email
    fill_in "user_password", :with => user.password
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
    fill_in "Email", :with => "email@person.com"
    click_button "Reset my password"

    user.reload

    visit spree.edit_user_password_path(:reset_password_token => user.reset_password_token)
    fill_in "Password", :with => "password"
    fill_in "Password Confirmation", :with => "password"
    click_button "Update my password and log me in"

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
    click_button "Save and Continue"
    page.should have_content("Your order has been processed successfully")

    Spree::Order.first.user.should == Spree::User.find_by_email("email@person.com")
  end

  it "the current payment method does not support profiles" do
    create(:authorize_net_payment_method, :environment => 'test')
    click_link "RoR Mug"
    click_button "Add To Cart"
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
    choose('Credit Card')
    fill_in "card_number", :with => "4111111111111111"
    fill_in "card_code", :with => "123"
    click_button "Save and Continue"
    page.should_not have_content("Confirm")
  end

  it "when no shipping methods have been configured" do
    Spree::ShippingMethod.delete_all

    click_link "RoR Mug"
    click_button "Add To Cart"
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
    page.should have_content("No shipping methods available")
  end

  it "when no payment methods have been configured" do
    Spree::PaymentMethod.delete_all

    click_link "RoR Mug"
    click_button "Add To Cart"
    click_button "Checkout"

    within("#guest_checkout") { fill_in "Email", :with => "spree@test.com" }
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
    page.should have_content("No payment methods are configured for this environment")
  end

  it "user submits an invalid credit card number" do
    create(:bogus_payment_method, :environment => 'test')
    click_link "RoR Mug"
    click_button "Add To Cart"
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
    choose('Credit Card')
    fill_in "card_number", :with => "1234567890"
    fill_in "card_code", :with => "000"
    click_button "Save and Continue"
    click_button "Place Order"
    page.should have_content("Payment could not be processed")
  end

  it "completing checkout for a free order, skipping payment step" do
    create(:free_shipping_method, :zone => zone)
    create(:payment_method, :environment => 'test')
    click_link "RoR Mug"
    click_button "Add To Cart"
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
    click_button "Save and Continue"
    page.should have_content("Your order has been processed successfully")
  end

  it "completing checkout with an invalid address input initially" do
    create(:bogus_payment_method, :environment => 'test')
    click_link "RoR Mug"
    click_button "Add To Cart"
    click_button "Checkout"

    within('#guest_checkout') { fill_in "Email", :with => "spree@test.com" }
    click_button "Continue"
    page.should have_content("Shipping Address")
    page.should have_content("Billing Address")

    fill_in "First Name", :with => "Test"
    click_button "Save and Continue"
    page.should have_content("This field is required")

    str_addr = "bill_address"
    select "United States", :from => "order_#{str_addr}_attributes_country_id"
    ['firstname', 'lastname', 'address1', 'city', 'zipcode', 'phone'].each do |field|
      fill_in "order_#{str_addr}_attributes_#{field}", :with => "#{address.send(field)}"
    end
    select "#{address.state.name}", :from => "order_#{str_addr}_attributes_state_id"
    check "order_use_billing"
    click_button "Save and Continue"
    page.should have_content("Shipping Method")
  end

  it "changing country to different zone during checkout should reset shipments" do
    eu_vat_zone = Spree::Zone.create!(:name => "EU_VAT")
    italy = create(:country, :iso_name => "ITALY", :iso => "IT", :iso3 => "ITA", :name => "Italy")
    eu_vat_zone.zone_members.create!(:zoneable => italy)
    ita_address = create(:address, :country => italy, :state_name => "Roma")
    eu_shipping = create(:shipping_method, :name => "EU", :zone => eu_vat_zone)
    # TODO: Figure why calculator after_create is not firing to set this
    eu_shipping.calculator.set_preference(:amount, 20)
    user = create(:user, :email => "email@person.com", :password => "password", :password_confirmation => "password")
    visit spree.login_path
    fill_in "user_email", :with => user.email
    fill_in "user_password", :with => user.password
    click_button "Login"
    click_link "RoR Mug"
    click_button "Add To Cart"

    page.should have_content("RoR Mug")
    within('h1') { page.should have_content("Shopping Cart") }

    click_button "Checkout"

    str_addr = "bill_address"
    select "United States", :from => "order_#{str_addr}_attributes_country_id"
    ['firstname', 'lastname', 'address1', 'city', 'zipcode', 'phone'].each do |field|
      fill_in "order_#{str_addr}_attributes_#{field}", :with => "#{ita_address.send(field)}"
    end
    select "Alabama", :from => "order_#{str_addr}_attributes_state_id"
    check "order_use_billing"
    click_button "Save and Continue"
    click_button "Save and Continue"
    page.should have_content("Shipping: $10.00")
    click_link "Address"

    select "Italy", :from => "order_#{str_addr}_attributes_country_id"
    ['firstname', 'lastname', 'address1', 'city', 'zipcode', 'phone'].each do |field|
      fill_in "order_#{str_addr}_attributes_#{field}", :with => "#{ita_address.send(field)}"
    end
    fill_in "order_#{str_addr}_attributes_state_name", :with => "#{ita_address.state_name}"
    check "order_use_billing"
    click_button "Save and Continue"
    choose "EU $20.00"
    click_button "Save and Continue"
    page.should have_content("Shipping: $20.00")
  end
end
