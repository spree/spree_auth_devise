require 'spec_helper'

describe "Reset Password" do
  before do
    ActionMailer::Base.default_url_options[:host] = "http://example.com"
  end

  it "should allow a user to supply an email for the password reset" do
    user = create(:user, :email => "foobar@example.com", :password => "secret", :password_confirmation => "secret")
    visit spree.login_path
    click_link "Forgot Password?"
    fill_in "Email", :with => "foobar@example.com"
    click_button "Reset my password"
    page.should have_content("You will receive an email with instructions")
  end

  it "shows errors if no email is supplied" do
    visit spree.login_path
    click_link "Forgot Password?"
    click_button "Reset my password"
    page.should have_content("Email can't be blank")
  end
end
