RSpec.feature 'Admin - Sign Out', type: :feature do
  given!(:user) do
   create :user, email: 'email@person.com'
  end

  background do
    visit spree.admin_login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'secret'
    # Regression test for #1257
    check 'Remember me'
    click_button Spree.t(:login)
  end

  scenario 'allows a signed in user to logout', js: true do
    log_out
    visit spree.admin_login_path
    expect(page).to have_button Spree.t(:login)
    expect(page).not_to have_text Spree.t(:logout)
  end
end
