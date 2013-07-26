require 'spec_helper'

describe 'Change email' do

  before do
    user = create(:user)
    visit spree.root_path
    click_link 'Login'
    fill_in 'spree_user[email]', with: user.email
    fill_in 'spree_user[password]', with: 'secret'
    click_button 'Login'
    visit spree.edit_account_path
  end

  it "should work with correct password" do
    fill_in "user_email", :with => "tests@example.com"
    fill_in "user_password", :with => 'password'
    fill_in "user_password_confirmation", :with => 'password'
    click_button "Update"
    page.should have_content("Account updated")
    page.should have_content('tests@example.com')
  end

end
