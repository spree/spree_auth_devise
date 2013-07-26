require 'spec_helper'

describe "Payment methods" do
  before do
    sign_in_as!(create(:admin_user))

    visit spree.admin_path
    click_link "Configuration"
  end

  # Regression test for #5
  it "can dismiss the banner" do
    Spree::User.any_instance.stub(:dismissed_banner? => false)
    Spree::PaymentMethod.stub(:production).and_return(payment_methods = [stub])
    payment_methods.stub(:where).and_return([])
    click_link "Payment Methods"
  end




end
