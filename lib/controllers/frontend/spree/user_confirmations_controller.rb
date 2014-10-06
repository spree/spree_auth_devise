class Spree::UserConfirmationsController < Devise::ConfirmationsController
  helper 'spree/base', 'spree/store'

  protected
  def after_confirmation_path_for(resource_name, resource)
    if signed_in?(resource_name)
      signed_in_root_path(resource)
    else
      login_path
    end
  end
end