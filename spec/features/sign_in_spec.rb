RSpec.feature 'Sign In', type: :feature do
  before do
    @user = create(:user, email: 'email@person.com', password: 'secret', password_confirmation: 'secret')
    visit spree.login_path
  end

  it 'ask user to sign in' do
    visit spree.admin_path
    expect(page).not_to have_text 'Authorization Failure'
  end

  it 'let a user sign in successfully', js: true do
    log_in(email: @user.email, password: @user.password)
    show_user_menu

    expect(page).not_to have_text login_button.upcase
    expect(page).to have_text logout_button.upcase
    expect(current_path).to eq '/account'
  end

  it 'show validation errors' do
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: 'wrong_password'
    click_button login_button

    expect(page).to have_text 'Invalid email or password'
    expect(page).to have_text 'Log in'
  end

  it 'allow a user to access a restricted page after logging in' do
    user = create(:admin_user, email: 'admin@person.com', password: 'password', password_confirmation: 'password')
    visit spree.admin_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password

    if Spree.version.to_f > 4.1
      click_button login_button
      within '.navbar .dropdown-menu-right' do
        expect(page).to have_text 'admin@person.com'
      end
    else
      click_button login_button
      within '.user-menu' do
        expect(page).to have_text 'admin@person.com'
      end
    end
    expect(current_path).to match('/admin')
  end

  it 'should store the user previous location' do
    visit spree.account_path
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_button login_button
    expect(current_path).to eq '/account'
  end

  context 'localized', js: true do
    before do
      if Spree.version.to_f >= 4.2
        add_french_locales
        Spree::Store.default.update(default_locale: 'en', supported_locales: 'en,fr')
        I18n.locale = :fr
      end
    end

    after { I18n.locale = :en }

    it 'let a user sign in successfully' do
      skip if Spree.version.to_f < 4.2
      log_in(email: @user.email, password: @user.password, locale: :fr)
      show_user_menu

      expect(page).not_to have_text Spree.t(:login).upcase
      expect(page).to have_text Spree.t(:logout).upcase
      expect(current_url).to match(/\/fr\/account/)
    end
  end
end
