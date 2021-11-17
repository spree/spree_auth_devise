class Spree::UserConfirmationsController < Devise::ConfirmationsController
  helper 'spree/base'

  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::Common
  include Spree::Core::ControllerHelpers::Order
  include Spree::Core::ControllerHelpers::Store

  include SpreeI18n::ControllerLocaleHelper if defined?(SpreeI18n::ControllerLocaleHelper)

  include Spree::Core::ControllerHelpers::Currency if defined?(Spree::Core::ControllerHelpers::Currency)
  include Spree::Core::ControllerHelpers::Locale if defined?(Spree::Core::ControllerHelpers::Locale)

  include Spree::LocaleUrls if defined?(Spree::LocaleUrls)

  helper 'spree/locale' if defined?(Spree::LocaleHelper)
  helper 'spree/currency' if defined?(Spree::CurrencyHelper)
  helper 'spree/store' if defined?(Spree::StoreHelper)

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    if resource.errors.empty?
      set_flash_message!(:notice, :confirmed)
      respond_with_navigational(resource) do
        redirect_to after_confirmation_path_for(resource_name, resource)
      end
    elsif resource.confirmed?
      set_flash_message(:error, :already_confirmed)
      respond_with_navigational(resource) do
        redirect_to after_confirmation_path_for(resource_name, resource)
      end
    else
      respond_with_navigational(resource.errors, status: :unprocessable_entity) do
        render :new
      end
    end
  end

  protected

  def after_confirmation_path_for(resource_name, resource)
    signed_in?(resource_name) ? signed_in_root_path(resource) : spree.login_path
  end

  def translation_scope
    'devise.confirmations'
  end
end
