class Spree::UserPasswordsController < Devise::PasswordsController
  include SslRequirement
  helper 'spree/users', 'spree/base'

  if defined?(Spree::Dash)
    helper 'spree/analytics'
  end

  include Spree::Core::ControllerHelpers

  ssl_required

  # Temporary Override until next Devise release (i.e after v1.3.4)
  # line:
  #   respond_with resource, :location => new_session_path(resource_name)
  # is generating bad url /session/new.user
  #
  # overridden to:
  #   respond_with resource, :location => login_path
  #
  def create
    self.resource = resource_class.send_reset_password_instructions(params[resource_name])

    if resource.errors.empty?
      set_flash_message(:notice, :send_instructions) if is_navigational_format?
      respond_with resource, :location => spree.login_path
    else
      respond_with_navigational(resource) { render :new }
    end
  end

end
