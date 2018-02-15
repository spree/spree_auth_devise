RSpec.feature 'Accounts', type: :feature do
  describe 'editing', js: true do
    before do
      allow_bypass_sign_in
    end

    scenario 'can edit an admin user' do
      user = create(:admin_user, email: 'admin@person.com', password: 'password', password_confirmation: 'password')
      visit spree.login_path

      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Login'

      click_link 'My Account'
      expect(page).to have_text 'admin@person.com'
    end

    scenario 'can edit a new user' do
      visit spree.signup_path

      fill_in 'Email', with: 'email@person.com'
      fill_in 'Password', with: 'password'
      fill_in 'Password Confirmation', with: 'password'
      click_button 'Create'

      click_link 'My Account'
      expect(page).to have_text 'email@person.com'
      click_link 'Edit'

      fill_in 'Password', with: 'foobar'
      fill_in 'Password Confirmation', with: 'foobar'
      click_button 'Update'

      expect(page).to have_text 'email@person.com'
      expect(page).to have_text 'Account updated'
    end

    scenario 'can edit an existing user account' do
      user = create(:user, email: 'email@person.com', password: 'secret', password_confirmation: 'secret')
      visit spree.login_path

      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Login'

      click_link 'My Account'
      expect(page).to have_text 'email@person.com'
      click_link 'Edit'

      fill_in 'Password', with: 'foobar'
      fill_in 'Password Confirmation', with: 'foobar'
      click_button 'Update'

      expect(page).to have_text 'email@person.com'
      expect(page).to have_text 'Account updated'
    end
  end
end
