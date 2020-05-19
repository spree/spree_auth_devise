module Spree
  module Api
    module V2
      module Storefront
        module AccountControllerDecorator
          def self.prepended(base)
            base.skip_before_action :require_spree_current_user, only: [:create]
          end

          def create
            user = Spree.user_class.new(spree_user_params)
            if user.save
              render_serialized_payload { serialize_resource(user) }
            else
              render_error_payload(structed_error(user.errors))
            end
          end

          def spree_user_params
            params.require(:user).permit(Spree::PermittedAttributes.user_attributes)
          end

          def structed_error(error)
            struct_error = Struct.new(:error) do
              def to_s
                return error.full_messages.join(', ') if error&.respond_to?(:full_messages)

                value.to_s
              end

              def to_h
                return error.messages if error&.respond_to?(:messages)

                {}
              end
            end

            struct_error.new(error)
          end
        end
      end
    end
  end
end

::Spree::Api::V2::Storefront::AccountController.prepend(Spree::Api::V2::Storefront::AccountControllerDecorator)
