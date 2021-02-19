RSpec.feature 'Checkout', :js, type: :feature do
  given!(:country) { create(:country, name: 'United States', states_required: true) }
  given!(:state)   { create(:state, name: 'Maryland', country: country) }
  given!(:shipping_method) do
    shipping_method = create(:shipping_method)
    calculator = Spree::Calculator::Shipping::PerItem.create!(calculable: shipping_method, preferred_amount: 10)
    shipping_method.calculator = calculator
    shipping_method.tap(&:save)
  end

  given!(:user) { create(:user, email: 'email@person.com', password: 'password', password_confirmation: 'password') }
  given!(:zone)    { create(:zone) }
  given!(:address) { create(:address, state: state, country: country) }
  given!(:mug) { create(:product, name: 'RoR Mug') }

  background do
    mug.master.stock_items.first.update_column(:count_on_hand, 1)

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
      add_to_cart(mug)
      click_link 'checkout'

      expect(page).to have_selector(:button, 'Continue as a guest')

      within('#checkout_form_registration') { fill_in 'Email', with: 'spree@test.com' }
      click_button 'Continue'

      expect(page).to have_text(/Billing Address/i)
      expect(page).to have_text(/Shipping Address/i)

      fill_in_address
      click_button 'Save and Continue'
      click_button 'Save and Continue'

      expect(page).to have_text 'Order placed successfully'
    end

    scenario 'associate an uncompleted guest order with user after logging in' do
      add_to_cart(mug)

      visit spree.login_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button login_button
      expect(page).to have_text('Logged in successfully')
      find('a.cart-icon').click

      expect(page).to have_text 'RoR Mug'
      within('h1') { expect(page).to have_text 'YOUR SHOPPING CART' }

      click_link 'checkout'

      fill_in_address
      click_button 'Save and Continue'
      click_button 'Save and Continue'

      expect(page).to have_text 'Order placed successfully'
      expect(Spree::Order.first.user).to eq user
    end

    # Regression test for #890
    scenario 'associate an incomplete guest order with user after successful password reset' do
      add_to_cart(mug)

      visit spree.login_path
      click_link 'Forgot password?'
      fill_in('Email', with: 'email@person.com')
      find('#spree_user_email').set('email@person.com')

      click_button 'Reset my password'

      # Need to do this now because the token stored in the DB is the encrypted version
      # The 'plain-text' version is sent in the email and there's one way to get that!
      reset_password_email = ActionMailer::Base.deliveries.first
      token_url_regex = /^http:\/\/www.example.com\/user\/spree_user\/password\/edit\?reset_password_token=(.*)$/
      token = token_url_regex.match(reset_password_email.body.encoded)[1]

      visit spree.edit_spree_user_password_path(reset_password_token: token.strip).tr("%0D","")
      fill_in 'Password', with: 'password'
      fill_in 'Password Confirmation', with: 'password'
      click_button 'Update'

      expect(page).to have_text('Your password was changed successfully')
      find('a.cart-icon').click
      expect(page).to have_text('RoR Mug')
      click_link 'checkout'

      fill_in_address
      click_button 'Save and Continue'

      expect(page).not_to have_text 'Email is invalid'
    end

    scenario 'allow a user to register during checkout' do
      add_to_cart(mug)
      click_link 'checkout'

      expect(page).to have_selector(:link, 'Sign Up')

      click_link 'Sign Up'

      fill_in 'Email', with: 'test@person.com'
      fill_in 'Password', with: 'spree123'
      fill_in 'Password Confirmation', with: 'spree123'

      click_button 'Sign Up'

      expect(page).to have_text 'You have signed up successfully.'

      fill_in_address
      click_button 'Save and Continue'
      click_button 'Save and Continue'

      expect(page).to have_text 'Order placed successfully'
      expect(Spree::Order.first.user).to eq Spree.user_class.find_by_email('test@person.com')
    end
  end
end
