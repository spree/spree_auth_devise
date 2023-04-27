RSpec.feature 'Admin - Sign In', type: :feature do
  let(:user) { create(:admin_user) }

  context 'when a user visits the admin_path' do
    describe 'when the user is not signed in' do
      it 'asks the user to sign in' do
        visit spree.admin_path

        expect(page).not_to have_text 'Authorization Failure'
      end
    end

    describe 'when the user is signed in' do
      it 'lets a user sign in successfully and access the admin UI' do
        admin_login(email: user.email, password: 'secret')

        assert_admin_login_success
      end
    end
  end

  context 'with non default locale' do
    before do
      add_french_locales

      Spree::Store.default.update(default_locale: 'en', supported_locales: 'en,fr')
      I18n.locale = :fr
    end

    after { I18n.locale = :en }

    describe 'admin login in french' do
      it 'lets a user sign in successfully' do
        admin_login(email: user.email, password: 'secret', locale: :fr)

        assert_admin_login_success(:fr)
      end
    end
  end

  it 'shows validation errors' do
    admin_login(email: user.email, password: 'wrong_password')

    expect(page).to have_text 'Invalid email or password'
    expect(page).to have_button 'Login'
  end

  it 'allows a user to access a restricted page after logging in' do
    admin_login(email: user.email, password: 'secret')

    assert_admin_login_success
  end
end
