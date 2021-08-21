RSpec.feature 'Admin orders', type: :feature do
  background do
    user = create(:admin_user)
    log_in email: user.email, password: user.password
  end

  # Regression #203
  scenario 'can list orders' do
    expect { visit spree.admin_orders_path }.not_to raise_error
  end

  # Regression #203
  scenario 'can new orders' do
    expect { visit spree.new_admin_order_path }.not_to raise_error
  end

  # Regression #203
  scenario 'can not edit orders' do
    visit spree.edit_admin_order_path('nodata')
    expect(page).to have_text('Order is not found')
  end

  # Regression #203
  scenario 'can edit orders' do
    create(:order, number: 'R123')
    visit spree.edit_admin_order_path('R123')
    expect(page).not_to have_text 'Authorization Failure'
  end
end
