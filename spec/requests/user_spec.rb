require 'spec_helper'

describe "Users" do
  before(:each) do
    Spree::Role.create!(:name => "user")
    user = create(:admin_user, :email => "admin@person.com", :password => "password", :password_confirmation => "password")
    visit spree.admin_path
    fill_in "Email", :with => user.email
    fill_in "Password", :with => user.password
    click_button "Login"
    click_link "Users"
    within('table#listing_users td.user_email') { click_link "admin@person.com" }
    click_link "Edit"
    page.should have_content("Editing User")
  end

  it "admin editing email with validation error" do
    fill_in "Email", :with => "a"
    click_button "Update"
    page.should have_content("Email is invalid")
  end

  it "admin editing roles" do
    check "user_spree_role_user"
    click_button "Update"
    page.should have_content("Account updated")
    find_field('user_spree_role_user')['checked'].should be_true
  end
end
