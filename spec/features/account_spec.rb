RSpec.feature 'Accounts', type: :feature do

  context 'editing' do
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
      Spree::Auth::Config.set(signout_after_password_change: false)
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
      Spree::Auth::Config.set(signout_after_password_change: false)
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
