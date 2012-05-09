module Spree
  module Core
    module ControllerHelpers
      def associate_user
        return unless spree_current_user and current_order
        current_order.associate_user!(spree_current_user)
        session[:guest_token] = nil
      end

      def spree_current_user
        current_user
      end
    end
  end
end


