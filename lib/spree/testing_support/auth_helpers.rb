module Spree
  module TestingSupport
    module AuthHelpers
      def log_in(email:, password:, remember_me: true)
        visit spree.login_path

        fill_in 'Email', with: email
        fill_in 'Password', with: password

        # Regression test for #1257
        first('label', text: 'Remember me').click if remember_me
        click_button 'Log in'

        expect(page).to have_content "Logged in successfully"
      end

      def log_out
        show_user_menu
        click_link 'LOG OUT'

        expect(page).to have_content "Signed out successfully"
      end

      def show_user_menu
        find("button[aria-label='Show user menu']").click
      end
    end
  end
end
