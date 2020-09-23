module Spree
  module AuthenticationHelpers
    def self.included(receiver)
      receiver.send :helper_method, :spree_current_user
      receiver.send :helper_method, :spree_login_path
      receiver.send :helper_method, :spree_signup_path if Spree::Auth::Config[:registerable]
      receiver.send :helper_method, :spree_logout_path
    end

    def spree_current_user
      current_spree_user
    end

    def spree_login_path
      spree.login_path
    end

    def spree_signup_path
      return spree.root_path unless Spree::Auth::Config[:registerable]

      spree.signup_path
    end

    def spree_logout_path
      spree.logout_path
    end
  end
end
