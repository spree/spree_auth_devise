require 'spec_helper'

feature 'Admin products' do
  context 'as anonymous user' do
    # regression test for #1250
    scenario 'is redirected to login page when attempting to access product listing' do
      expect { visit spree.admin_products_path }.not_to raise_error
    end
  end
end
