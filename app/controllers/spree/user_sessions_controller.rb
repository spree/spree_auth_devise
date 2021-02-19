class Spree::UserSessionsController < Devise::SessionsController
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

  before_action :set_current_order

  def create
    authenticate_spree_user!

    if spree_user_signed_in?
      respond_to do |format|
        format.html {
          flash[:success] = Spree.t(:logged_in_succesfully)
          redirect_back_or_default(after_sign_in_redirect(spree_current_user))
        }
        format.js {
          render json: { user: spree_current_user,
                           ship_address: spree_current_user.ship_address,
                           bill_address: spree_current_user.bill_address }.to_json
        }
      end
    else
      respond_to do |format|
        format.html {
          flash.now[:error] = t('devise.failure.invalid')
          render :new
        }
        format.js {
          render json: { error: t('devise.failure.invalid') }, status: :unprocessable_entity
        }
      end
    end
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

  def after_sign_in_redirect(resource_or_scope)
    stored_location_for(resource_or_scope) || spree.account_path
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
    context.respond_to?(:login_path) ? context.login_path : spree.root_path
  end
end
