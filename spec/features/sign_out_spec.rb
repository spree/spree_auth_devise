RSpec.feature 'Sign Out', type: :feature, js: true do
  given!(:user) do
    create(:user,
          email: 'email@person.com',
          password: 'secret',
          password_confirmation: 'secret')
  end

  background do
    visit spree.login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    # Regression test for #1257
    check 'Remember me'
    click_button 'Login'
  end

  scenario 'allow a signed in user to logout' do
    click_link 'Logout'
    visit spree.root_path
    expect(page).to have_text 'Login'
    expect(page).not_to have_text 'Logout'
  end

  describe 'before_logout' do
    before do
      create(:product, name: 'RoR Mug')
      create(:product, name: 'RoR Shirt')
    end

    let!(:other_user) { create(:user) }

    it 'clears token cookies' do
      visit spree.root_path

      click_link 'RoR Mug'
      click_button 'Add To Cart'

      click_link 'Cart'
      expect(page).to have_text 'RoR Mug'

      click_link 'Logout'

      click_link 'Cart'
      expect(page).to have_text Spree.t(:your_cart_is_empty)

      visit spree.login_path
      fill_in 'Email', with: other_user.email
      fill_in 'Password', with: other_user.password
      click_button 'Login'

      click_link 'Cart'
      expect(page).to have_text Spree.t(:your_cart_is_empty)
    end
  end
end
