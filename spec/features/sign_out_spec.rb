RSpec.feature 'Sign Out', type: :feature do

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

  scenario 'restrict signing out by a GET request' do
    expect do
      visit spree.logout_path
    end.to raise_error(ActionController::RoutingError)
    visit spree.login_path
    expect(page).to have_text('You are already signed in')
  end
end
