RSpec.feature 'Payment methods', type: :feature do

  background do
    sign_in_as! create(:admin_user)
    visit spree.admin_path
    click_link 'Configuration'
  end

  # Regression test for #5
  scenario 'can dismiss the banner' do
    allow_any_instance_of(Spree::User).to receive(:dismissed_banner?) { false }
    allow(Spree::PaymentMethod).to receive(:production).and_return(payment_methods = [double])
    allow(payment_methods).to receive(:where).and_return([])
    click_link 'Payment Methods'
  end
end
