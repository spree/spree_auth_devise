RSpec.feature 'Orders', :js, type: :feature do
  scenario 'allow a user to view their cart at any time' do
    visit spree.cart_path
    expect(page).to have_text 'Your cart is empty'
  end

  # regression test for spree/spree#1687
  scenario 'merge incomplete orders from different sessions' do
    ror_mug = create(:product, name: 'RoR Mug')
    ror_shirt = create(:product, name: 'RoR Shirt')

    user = create(:user, email: 'email@person.com', password: 'password', password_confirmation: 'password')

    using_session('first') do
      add_to_cart ror_mug

      visit spree.login_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button login_button

      visit spree.cart_path
      expect(page).to have_text 'RoR Mug'
    end

    using_session('second') do
      add_to_cart ror_shirt

      visit spree.login_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button login_button

      # Order should have been merged with first session
      visit spree.cart_path
      expect(page).to have_text 'RoR Mug'
      expect(page).to have_text 'RoR Shirt'
    end

    using_session('first') do
      visit spree.root_path
      visit spree.cart_path

      # Order should have been merged with second session
      expect(page).to have_text 'RoR Mug'
      expect(page).to have_text 'RoR Shirt'
    end
  end
end
