require 'spec_helper'

RSpec.feature 'Confirmation', type: :feature, confirmable: true do
  before do
    expect(Spree::UserMailer).to receive(:confirmation_instructions).with(anything, anything, { current_store_id: Spree::Store.current.id }).and_return(double(deliver: true))
  end

  background do
    ActionMailer::Base.default_url_options[:host] = 'http://example.com'
  end

  scenario 'create a new user' do
    visit spree.signup_path

    fill_in 'Email', with: 'email@person.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password Confirmation', with: 'password'
    click_button 'Sign Up'

    expect(page).to have_text I18n.t('devise.user_registrations.signed_up_but_unconfirmed')
    expect(Spree.user_class.last.confirmed?).to be(false)
  end
end
