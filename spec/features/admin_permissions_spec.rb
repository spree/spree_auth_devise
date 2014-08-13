RSpec.feature 'Admin Permissions', type: :feature do

  context 'orders' do
    background do
      user = create(:admin_user, email: 'admin@person.com', password: 'password', password_confirmation: 'password')
      Spree::Ability.register_ability(AbilityDecorator)
      visit spree.login_path

      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Login'
    end

    context 'admin is restricted from accessing orders' do
      scenario 'can not list orders' do
        visit spree.admin_orders_path
        expect(page).to have_text 'Authorization Failure'
      end

      scenario 'can not edit orders' do
        create(:order, number: 'R123')
        visit spree.edit_admin_order_path('R123')
        expect(page).to have_text 'Authorization Failure'
      end

      scenario 'can not new orders' do
        visit spree.new_admin_order_path
        expect(page).to have_text 'Authorization Failure'
      end
    end

    context "admin is restricted from accessing an order's customer details" do
      given(:order) { create(:order_with_totals) }

      scenario 'can not list customer details for an order' do
        visit spree.admin_order_customer_path(order)
        expect(page).to have_text 'Authorization Failure'
      end

      scenario "can not edit an order's customer details" do
        visit spree.edit_admin_order_customer_path(order)
        expect(page).to have_text 'Authorization Failure'
      end
    end
  end
end
