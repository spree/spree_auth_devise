RSpec.feature 'Admin - Reset Password', type: :feature do
  background do
    ActionMailer::Base.default_url_options[:host] = 'http://example.com'
  end

  scenario 'allows a user to supply an email for the password reset' do
    user = create(:user, email: 'foobar@example.com', password: 'secret', password_confirmation: 'secret')
    visit spree.admin_login_path
    click_link 'Forgot password?'
    fill_in 'Email', with: user.email
    click_button 'Reset my password'
    expect(page).to have_text 'You will receive an email with instructions'
  end

  scenario 'shows errors if no email is supplied' do
    visit spree.admin_login_path
    click_link 'Forgot password?'
    click_button 'Reset my password'
    expect(page).to have_text "Email can't be blank"
  end
end
