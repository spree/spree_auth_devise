# frozen_string_literal: true

RSpec.feature 'Admin - Sign Out', type: :feature, js: false do
  let(:user) { create(:admin_user, email: 'email@person.com') }

  before do
    admin_login(email: user.email, password: 'secret')
  end

  it 'allows a signed in user to logout' do
    find(:xpath, "/html/body/header/nav/div[3]/div/div/a[3]").click

    visit spree.admin_path

    expect(page).to have_button Spree.t(:login)
    expect(page).not_to have_text Spree.t(:logout)
  end
end
