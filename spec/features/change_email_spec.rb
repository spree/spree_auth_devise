# frozen_string_literal: true

RSpec.feature 'Change email', type: :feature do
  before do
    allow_bypass_sign_in
    I18n.locale = :en

    user = create(:user, email: 'old@spree.com', password: 'secret')
    log_in(email: user.email, password: 'secret')
    visit spree.edit_account_path
  end

  describe 'work with correct password', js: true do
    it 'Updates account' do
      fill_in 'user_email', with: 'tests@example.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
      click_button 'Update'

      expect(page).to have_text 'Account updated'
      expect(page).to have_text 'tests@example.com'
    end
  end
end
