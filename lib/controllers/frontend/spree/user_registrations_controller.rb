class Spree::UserRegistrationsController < Devise::RegistrationsController
  helper 'spree/base'

  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::Common
  include Spree::Core::ControllerHelpers::Order
  include Spree::Core::ControllerHelpers::Store

  before_action :check_permissions, only: [:edit, :update]
  skip_before_action :require_no_authentication

  # GET /resource/sign_up
  def new
    super
    @user = resource
  end

  # POST /resource/sign_up
  def create
    @user = build_resource(spree_user_params)
    resource_saved = resource.save
    yield resource if block_given?
    if resource_saved
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up
        sign_up(resource_name, resource)
        session[:spree_user_signup] = true
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
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

  private

  def spree_user_params
    params.require(:spree_user).permit(Spree::PermittedAttributes.user_attributes)
  end
end
