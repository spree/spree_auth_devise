module Spree
  module Core
    module ControllerHelpers
      def associate_user
        p method(:spree_current_user).source_location
        p spree_current_user
        return unless spree_current_user and current_order
        current_order.associate_user!(spree_current_user)
        session[:guest_token] = nil
      end
    end
  end
end


