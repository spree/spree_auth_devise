class Spree::UserRegistrationsController < Devise::RegistrationsController
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

  before_action :check_permissions, only: [:edit, :update]
  before_action :set_current_order
  skip_before_action :require_no_authentication

  # GET /resource/sign_up
  def new
    super
    @user = resource
  end

  # POST /resource/sign_up
  def create
    @user = build_resource(spree_user_params)
    resource.skip_confirmation_notification! if Spree::Auth::Config[:confirmable]
    resource_saved = resource.save
    yield resource if block_given?
    if resource_saved
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up
        sign_up(resource_name, resource)
        session[:spree_user_signup] = true
        resource.send_confirmation_instructions(current_store) if Spree::Auth::Config[:confirmable]
        redirect_to_checkout_or_account_path(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        resource.send_confirmation_instructions(current_store) if Spree::Auth::Config[:confirmable]
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords(resource)
      render :new
    end
  end

  # GET /resource/edit
  def edit
    super
  end

  # PUT /resource
  def update
    super
  end

  # DELETE /resource
  def destroy
    super
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    super
  end

  protected

  def check_permissions
    authorize!(:create, resource)
  end

  def translation_scope
    'devise.user_registrations'
  end

  def after_sign_up_path_for(resource)
    after_sign_in_redirect(resource) if is_navigational_format?
  end

  def after_inactive_sign_up_path_for(resource)
    scope = Devise::Mapping.find_scope!(resource)
    router_name = Devise.mappings[scope].router_name
    context = router_name ? send(router_name) : self
    context.respond_to?(:login_path) ? context.login_path : "/login"
  end

  private

  def accurate_title
    Spree.t(:sign_up)
  end

  def spree_user_params
    params.require(:spree_user).permit(Spree::PermittedAttributes.user_attributes)
  end

  def after_sign_in_redirect(resource_or_scope)
    stored_location_for(resource_or_scope) || account_path
  end

  def redirect_to_checkout_or_account_path(resource)
    resource_path = after_sign_up_path_for(resource)

    if resource_path == spree.checkout_state_path(:address)
      respond_with resource, location: spree.checkout_state_path(:address)
    else
      respond_with resource, location: spree.account_path
    end
  end
end
