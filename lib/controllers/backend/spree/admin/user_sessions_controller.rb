class Spree::Admin::UserSessionsController < Devise::SessionsController
  helper 'spree/base'

  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::Common
  include Spree::Core::ControllerHelpers::Store

  helper 'spree/admin/navigation'
  layout :resolve_layout

  def create
    authenticate_spree_user!

    if spree_user_signed_in?
      respond_to do |format|
        format.html {
          flash[:success] = Spree.t(:logged_in_successfully)
          redirect_back_or_default(after_sign_in_path_for(spree_current_user))
        }
        format.js {
          user = resource.record
          render json: { ship_address: user.ship_address, bill_address: user.bill_address }.to_json
        }
      end
    else
      flash.now[:error] = t('devise.failure.invalid')
      render :new
    end
  end

  def authorization_failure
    return if try_spree_current_user
    store_location
    return redirect_to spree.admin_login_path
  end

  protected

  def translation_scope
    'devise.user_sessions'
  end

  private

  def accurate_title
    Spree.t(:login)
  end

  def redirect_back_or_default(default)
    redirect_to(session["spree_user_return_to"] || default)
    session["spree_user_return_to"] = nil
  end

  def resolve_layout
    case action_name
    when "new", "create"
      "spree/layouts/login"
    else
      "spree/layouts/admin"
    end
  end

  def respond_to_on_destroy
    # We actually need to hardcode this as Rails default responder doesn't
    # support returning empty response on GET request
    respond_to do |format|
      format.all { head :no_content }
      format.any(*navigational_formats) { redirect_to after_sign_out_redirect(resource_name) }
    end
  end

  def after_sign_out_redirect(resource_or_scope)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    router_name = Devise.mappings[scope].router_name
    context = router_name ? send(router_name) : self
    context.respond_to?(:admin_login_path) ? context.admin_login_path : "/"
  end
end
