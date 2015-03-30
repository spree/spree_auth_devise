RSpec.feature 'Checkout', :js, type: :feature do
  given!(:store) { create(:store) }
  given!(:country) { create(:country, name: 'United States', states_required: true) }
  given!(:state)   { create(:state, name: 'Maryland', country: country) }
  given!(:shipping_method) do
    shipping_method = create(:shipping_method)
    calculator = Spree::Calculator::Shipping::PerItem.create!(calculable: shipping_method, preferred_amount: 10)
    shipping_method.calculator = calculator
    shipping_method.tap(&:save)
  end

  given!(:zone)    { create(:zone) }
  given!(:address) { create(:address, state: state, country: country) }

  background do
    @product = create(:product, name: 'RoR Mug')
    @product.master.stock_items.first.update_column(:count_on_hand, 1)

    # Bypass gateway error on checkout | ..or stub a gateway
    Spree::Config[:allow_checkout_on_gateway_error] = true

    visit spree.root_path
  end

  context 'without payment being required' do
    background do
      # So that we don't have to setup payment methods just for the sake of it
      allow_any_instance_of(Spree::Order).to receive(:has_available_payment).and_return(true)
      allow_any_instance_of(Spree::Order).to receive(:payment_required?).and_return(false)
    end

    scenario 'allow a visitor to checkout as guest, without registration' do
      Spree::Auth::Config.set(registration_step: true)
      click_link 'RoR Mug'
      click_button 'Add To Cart'
      within('h1') { expect(page).to have_text 'Shopping Cart' }
      click_button 'Checkout'

      expect(page).to have_content(/Checkout as a Guest/i)

      within('#guest_checkout') { fill_in 'Email', with: 'spree@test.com' }
      click_button 'Continue'

      expect(page).to have_text(/Billing Address/i)
      expect(page).to have_text(/Shipping Address/i)

      str_addr = 'bill_address'
      select 'United States', from: "order_#{str_addr}_attributes_country_id"
      %w(firstname lastname address1 city zipcode phone).each do |field|
        fill_in "order_#{str_addr}_attributes_#{field}", with: "#{address.send(field)}"
      end
      select "#{address.state.name}", from: "order_#{str_addr}_attributes_state_id"
      check 'order_use_billing'

      click_button 'Save and Continue'
      click_button 'Save and Continue'

      expect(page).to have_text 'Your order has been processed successfully'
    end

    scenario 'associate an uncompleted guest order with user after logging in' do
      user = create(:user, email: 'email@person.com', password: 'password', password_confirmation: 'password')
      click_link 'RoR Mug'
      click_button 'Add To Cart'

      visit spree.login_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Login'
      click_link 'Cart'

      expect(page).to have_text 'RoR Mug'
      within('h1') { expect(page).to have_text 'Shopping Cart' }

      click_button 'Checkout'

      str_addr = 'bill_address'
      select 'United States', from: "order_#{str_addr}_attributes_country_id"
      %w(firstname lastname address1 city zipcode phone).each do |field|
        fill_in "order_#{str_addr}_attributes_#{field}", with: "#{address.send(field)}"
      end
      select "#{address.state.name}", from: "order_#{str_addr}_attributes_state_id"
      check 'order_use_billing'

      click_button 'Save and Continue'
      click_button 'Save and Continue'

      expect(page).to have_text 'Your order has been processed successfully'
      expect(Spree::Order.first.user).to eq user
    end

    # Regression test for #890
    scenario 'associate an incomplete guest order with user after successful password reset' do
      create(:store)
      user = create(:user, email: 'email@person.com', password: 'password', password_confirmation: 'password')
      click_link 'RoR Mug'
      click_button 'Add To Cart'

      visit spree.login_path
      click_link 'Forgot Password?'
      fill_in 'spree_user_email', with: 'email@person.com'
      click_button 'Reset my password'

      # Need to do this now because the token stored in the DB is the encrypted version
      # The 'plain-text' version is sent in the email and there's one way to get that!
      reset_password_email = ActionMailer::Base.deliveries.first
      token_url_regex = /^http:\/\/www.example.com\/user\/spree_user\/password\/edit\?reset_password_token=(.*)$/
      token = token_url_regex.match(reset_password_email.body.to_s)[1]

      visit spree.edit_spree_user_password_path(reset_password_token: token)
      fill_in 'Password', with: 'password'
      fill_in 'Password Confirmation', with: 'password'
      click_button 'Update'

      click_link 'Cart'
      click_button 'Checkout'

      str_addr = 'bill_address'
      select 'United States', from: "order_#{str_addr}_attributes_country_id"
      %w(firstname lastname address1 city zipcode phone).each do |field|
        fill_in "order_#{str_addr}_attributes_#{field}", with: "#{address.send(field)}"
      end
      select "#{address.state.name}", from: "order_#{str_addr}_attributes_state_id"
      check 'order_use_billing'

      click_button 'Save and Continue'

      expect(page).not_to have_text 'Email is invalid'
    end

    scenario 'allow a user to register during checkout' do
      click_link 'RoR Mug'
      click_button 'Add To Cart'
      click_button 'Checkout'

      expect(page).to have_text 'Registration'

      fill_in 'Email', with: 'email@person.com'
      fill_in 'Password', with: 'spree123'
      fill_in 'Password Confirmation', with: 'spree123'
      click_button 'Create'

      expect(page).to have_text 'You have signed up successfully.'

      str_addr = 'bill_address'
      select 'United States', from: "order_#{str_addr}_attributes_country_id"
      %w(firstname lastname address1 city zipcode phone).each do |field|
        fill_in "order_#{str_addr}_attributes_#{field}", with: "#{address.send(field)}"
      end
      select "#{address.state.name}", from: "order_#{str_addr}_attributes_state_id"
      check 'order_use_billing'

      click_button 'Save and Continue'
      click_button 'Save and Continue'

      expect(page).to have_text 'Your order has been processed successfully'
      expect(Spree::Order.first.user).to eq Spree::User.find_by_email('email@person.com')
    end
  end
end
