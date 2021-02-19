RSpec.feature 'Admin - Sign In', type: :feature do
  background do
    @user = create(:user, email: 'email@person.com')
    visit spree.admin_login_path
  end

  scenario 'asks user to sign in' do
    visit spree.admin_path
    expect(page).not_to have_text 'Authorization Failure'
  end

  scenario 'lets a user sign in successfully', js: true do
    log_in(email: @user.email, password: 'secret')
    show_user_menu

    expect(page).not_to have_text login_button.upcase
    expect(page).to have_text logout_button.upcase
    expect(current_path).to eq '/account'
  end

  scenario 'shows validation errors' do
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: 'wrong_password'
    click_button 'Login'

    expect(page).to have_text 'Invalid email or password'
    expect(page).to have_button 'Login'
  end

  scenario 'allows a user to access a restricted page after logging in' do
    user = create(:admin_user, email: 'admin@person.com')
    visit spree.admin_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'secret'
    click_button login_button

    if Spree.version.to_f > 4.1
      within '.navbar .dropdown-menu' do
        expect(page).to have_text 'admin@person.com'
      end
    else
      within '.user-menu' do
        expect(page).to have_text 'admin@person.com'
      end
    end
    expect(current_path).to eq '/admin/orders'
  end
end
