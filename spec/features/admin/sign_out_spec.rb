# frozen_string_literal: true

RSpec.feature 'Admin - Sign Out', type: :feature, js: true do
  let(:user) { create(:user, email: 'email@person.com') }

  before do
    I18n.locale = :en

    visit spree.admin_login_path

    fill_in 'Email', with: user.email
    fill_in Spree.t(:password), with: 'secret'

    # Regression test for #1257
    check 'Remember me'
    click_button Spree.t(:login)
  end

  describe 'allows a signed in user to logout' do
    it 'shows the login page' do
      log_out

      visit spree.admin_login_path(locale: 'en')

      expect(page).to have_button Spree.t(:login)
      expect(page).not_to have_text Spree.t(:logout)
    end
  end
end
