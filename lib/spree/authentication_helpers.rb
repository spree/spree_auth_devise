module Spree
  module AuthenticationHelpers
    def self.included(receiver)
      receiver.send :helper_method, :spree_current_user
      receiver.send :helper_method, :spree_login_path
      receiver.send :helper_method, :spree_signup_path
      receiver.send :helper_method, :spree_logout_path
    end

    def spree_current_user
      current_spree_user
    end

    def spree_login_path(opts = {})
      spree.login_path(opts)
    end

    def spree_signup_path(opts = {})
      spree.signup_path(opts)
    end

    def spree_logout_path(opts = {})
      spree.logout_path(opts)
    end
  end
end
