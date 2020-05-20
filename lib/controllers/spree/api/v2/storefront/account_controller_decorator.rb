module Spree
  module Api
    module V2
      module Storefront
        module AccountControllerDecorator
          def self.prepended(base)
            base.skip_before_action :require_spree_current_user, only: [:create]
          end

          def create
            result = Spree::Account::Create.call(user_params: spree_user_params)

            render_payload(result)
          end

          def update
            result = Spree::Account::Update.call(user: spree_current_user, user_params: spree_user_params)

            render_payload(result)
          end

          private

          def render_payload(result)
            if result.success?
              render_serialized_payload { serialize_resource(result.value) }
            else
              render_error_payload(result.error)
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
