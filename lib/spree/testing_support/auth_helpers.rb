module Spree
  module TestingSupport
    module AuthHelpers
      def login_button
        Spree.version.to_f == 4.1 ? Spree.t(:log_in) : Spree.t(:login)
      end

      def logout_button
        Spree.version.to_f == 4.1 ? Spree.t('nav_bar.log_out') : Spree.t(:logout).upcase
      end

      def log_in(email:, password:, remember_me: true, locale: nil)
        visit spree.login_path(locale: locale)

        fill_in Spree.t(:email), with: email
        fill_in Spree.t(:password), with: password

        # Regression test for #1257
        first('label', text: Spree.t(:remember_me)).click if remember_me
        click_button login_button

        expect(page).to have_content Spree.t(:logged_in_succesfully)
      end

      def log_out
        show_user_menu
        click_link logout_button

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
