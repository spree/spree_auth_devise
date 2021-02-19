module Spree
  module TestingSupport
    module AuthHelpers
      def log_in(email:, password:, remember_me: true, locale: nil)
        visit spree.login_path(locale: locale)

        fill_in Spree.t(:email), with: email
        fill_in Spree.t(:password), with: password

        # Regression test for #1257
        first('label', text: Spree.t(:remember_me)).click if remember_me
        click_button Spree.t(:login)

        expect(page).to have_content Spree.t(:logged_in_succesfully)
      end

      def log_out
        show_user_menu
        click_link Spree.t(:logout).upcase

        expect(page).to have_content 'Signed out successfully'
      end

      def show_user_menu
        find("button[aria-label='#{Spree.t('nav_bar.show_user_menu')}']").click
      end

      def show_user_account
        within '#nav-bar' do
          show_user_menu
          click_link Spree.t(:my_account).upcase
        end
      end
    end
  end
end
