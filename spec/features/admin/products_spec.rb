RSpec.feature 'Admin products', type: :feature do

  context 'as anonymous user' do
    # Regression test for #1250
    scenario 'redirects to login page when attempting to access product listing' do
      expect { visit spree.admin_products_path }.not_to raise_error
    end
  end
end
