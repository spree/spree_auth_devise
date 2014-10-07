require 'spec_helper'

feature 'Confirmation' do
  before { Spree::Auth::Config[:confirmable] = true }
  let!(:store) { create(:store) }

  background do
    ActionMailer::Base.default_url_options[:host] = 'http://example.com'
  end

  scenario 'create a new user' do
    visit spree.signup_path

    fill_in 'Email', with: 'email@person.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password Confirmation', with: 'password'
    click_button 'Create'

    expect(page).to have_text 'You have signed up successfully.'
    expect(Spree::User.last.confirmed?).to be(false)
  end
end