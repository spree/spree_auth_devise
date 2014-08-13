RSpec.feature 'Orders', :js, type: :feature do

  scenario 'allow a user to view their cart at any time' do
    visit spree.cart_path
    expect(page).to have_text 'Your cart is empty'
  end

  # regression test for spree/spree#1687
  scenario 'merge incomplete orders from different sessions' do
    skip %{
      TODO: has been broken for ~2 months as of:
      https://github.com/spree/spree_auth_devise/commit/3157b47b22c559817d34ec34024587d8aa6136dc
      I dont think we can decode these sessions anymore since Rails 4 switched to encrypted cookies I believe devise stores session encrypted.
    }
    create(:product, name: 'RoR Mug')
    create(:product, name: 'RoR Shirt')

    user = create(:user, email: 'email@person.com', password: 'password', password_confirmation: 'password')

    using_session('first') do
      visit spree.root_path

      click_link 'RoR Mug'
      click_button 'Add To Cart'

      visit spree.login_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Login'

      click_link 'Cart'
      expect(page).to have_text 'RoR Mug'
    end

    using_session('second') do
      visit spree.root_path

      click_link 'RoR Shirt'
      click_button 'Add To Cart'

      visit spree.login_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Login'

      # Order should have been merged with first session
      click_link 'Cart'
      expect(page).to have_text 'RoR Mug'
      expect(page).to have_text 'RoR Shirt'
    end

    using_session('first') do
      visit spree.root_path

      click_link 'Cart'

      # Order should have been merged with second session
      expect(page).to have_text 'RoR Mug'
      expect(page).to have_text 'RoR Shirt'
    end
  end
end
