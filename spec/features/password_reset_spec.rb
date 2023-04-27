# frozen_string_literal: true

RSpec.feature 'Reset Password', type: :feature do
  before do
    ActionMailer::Base.default_url_options[:host] = 'http://example.com'
  end

  it 'allow a user to supply an email for the password reset' do
    create(:user, email: 'foobar@example.com', password: 'secret', password_confirmation: 'secret')
    visit spree.login_path
    click_link 'Forgot password?'
    fill_in 'Email', with: 'foobar@example.com'
    click_button 'Reset my password'
    expect(page).to have_text 'You will receive an email with instructions'
  end

  it 'shows errors if no email is supplied' do
    visit spree.login_path
    click_link 'Forgot password?'
    click_button 'Reset my password'
    expect(page).to have_text "Email can't be blank"
  end
end
