RSpec.feature 'Sign Up', type: :feature do
  context 'with valid data' do
    scenario 'create a new user' do
      visit spree.signup_path

      fill_in 'Email', with: 'email@person.com'
      fill_in 'Password', with: 'password'
      fill_in 'Password Confirmation', with: 'password'

      click_button 'Sign Up'

      expect(page).to have_text 'You have signed up successfully.'
      expect(Spree.user_class.count).to eq(1)
    end
  end

  context 'with invalid data' do
    scenario 'does not create a new user' do
      visit spree.signup_path

      fill_in 'Email', with: 'email@person.com'
      fill_in 'Password', with: 'password'
      fill_in 'Password Confirmation', with: ''

      click_button 'Sign Up'

      expect(page).to have_css '#errorExplanation'
      expect(Spree.user_class.count).to eq(0)
    end
  end
end
