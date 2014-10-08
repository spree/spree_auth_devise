class Spree::UserConfirmationsController < Devise::ConfirmationsController
  helper 'spree/base', 'spree/store'

  if Spree::Auth::Engine.dash_available?
    helper 'spree/analytics'
  end

  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::Common
  include Spree::Core::ControllerHelpers::Order
  include Spree::Core::ControllerHelpers::SSL
  include Spree::Core::ControllerHelpers::Store

  ssl_required

  protected
  def after_confirmation_path_for(resource_name, resource)
    if signed_in?(resource_name)
      signed_in_root_path(resource)
    else
      login_path
    end
  end
end