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
    click_button 'Login'
  end

  scenario 'allows a signed in user to logout' do
    click_link 'Logout'
    visit spree.admin_login_path
    expect(page).to have_button 'Login'
    expect(page).not_to have_text 'Logout'
  end

  scenario 'does not allow logging out by a GET request' do
    expect do
      visit spree.admin_logout_path
    end.to raise_error(ActionController::RoutingError)
    visit spree.admin_login_path
    expect(page).to have_text('You are already signed in')
  end
end
