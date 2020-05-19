module Spree
  module Api
    module V2
      module Storefront
        module AccountControllerDecorator
          def self.prepended(base)
            base.skip_before_action :require_spree_current_user, only: [:create]
          end

          def create
            user = Spree.user_class.new_with_session(spree_user_params, session)
            if user.save
              render_serialized_payload { serialize_resource(user) }
            else
              render json: { errors: user.errors.messages }
            end
          end

          def spree_user_params
            params.require(:user).permit(Spree::PermittedAttributes.user_attributes)
          end
        end
      end
    end
  end
end

::Spree::Api::V2::Storefront::AccountController.prepend(Spree::Api::V2::Storefront::AccountControllerDecorator)
