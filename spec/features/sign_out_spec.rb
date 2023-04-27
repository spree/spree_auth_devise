RSpec.feature 'Sign Out', type: :feature, js: true do
  let!(:user) do
    create(:user,
           email: 'email@person.com',
           password: 'secret',
           password_confirmation: 'secret')
  end

  before do
    log_in(email: user.email, password: user.password)
  end

  it 'allow a signed in user to logout' do
    log_out_via_frontend_user_menu

    visit spree.root_path
    show_frontend_user_menu

    expect(page).to have_link login_button.upcase
    expect(page).not_to have_link logout_button.upcase
  end

  describe 'before_logout' do
    let!(:mug)        { create(:product_in_stock, name: 'RoR Mug') }
    let!(:shirt)      { create(:product, name: 'RoR Shirt') }
    let!(:other_user) { create(:user) }

    it 'clears token cookies' do
      add_to_cart(mug)

      log_out_via_frontend_user_menu

      find('#link-to-cart').click
      expect(page).to have_text Spree.t(:your_cart_is_empty)

      log_in(email: other_user.email, password: user.password)
      find('#link-to-cart').click

      expect(page).to have_text Spree.t(:your_cart_is_empty)
    end
  end
end
