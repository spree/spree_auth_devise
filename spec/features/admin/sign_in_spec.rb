require 'spec_helper'

feature 'Admin - Sign In' do
  background do
    @user = create(:user, email: 'email@person.com', password: 'secret', password_confirmation: 'secret')
    visit spree.admin_login_path
  end

  scenario 'ask user to sign in' do
    visit spree.admin_path
    expect(page).not_to have_text 'Authorization Failure'
  end

  scenario 'let a user sign in successfully' do
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Login'

    expect(page).to have_text 'Logged in successfully'
    expect(page).not_to have_text 'Login'
    expect(page).to have_text 'Logout'
    expect(current_path).to eq '/'
  end

  scenario 'show validation erros' do
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: 'wrong_password'
    click_button 'Login'

    expect(page).to have_text 'Invalid email or password'
    expect(page).to have_text 'Login'
  end

  scenario 'allow a user to access a restricted page after logging in' do
    user = create(:admin_user, email: 'admin@person.com', password: 'password', password_confirmation: 'password')
    visit spree.admin_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Login'

    expect(page).to have_text 'Logged in as: admin@person.com'
    expect(current_path).to eq '/admin'
  end
end
