require 'spec_helper'

describe "Admin Permissions" do
  context 'orders' do
    before do
      user = create(:admin_user, :email => "admin@person.com", :password => "password", :password_confirmation => "password")
      Spree::Ability.register_ability(AbilityDecorator)
      visit spree.login_path
      fill_in "Email", :with => user.email
      fill_in "Password", :with => user.password
      click_button "Login"
    end

    context "admin is restricted from accessing orders" do
      it "should not be able to list orders" do
        visit spree.admin_orders_path
        page.should have_content("Authorization Failure")
      end

      it "should not be able to edit orders" do
        create(:order, :number => "R123")
        visit spree.edit_admin_order_path("R123")
        page.should have_content("Authorization Failure")
      end
    end

    context "admin is restricted from accessing an order's customer details" do
      let(:order) { create(:order_with_totals)}

      it "should not be able to list customer details for an order" do
        visit spree.admin_order_customer_path(order)
        page.should have_content("Authorization Failure")
      end

      it "should not be able to edit an order's customer details" do
        visit spree.edit_admin_order_customer_path(order)
        page.should have_content("Authorization Failure")
      end
    end
  end
end
