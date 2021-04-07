class Spree::UserPasswordsController < Devise::PasswordsController
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

  # Overridden due to bug in Devise.
  #   respond_with resource, :location => new_session_path(resource_name)
  # is generating bad url /session/new.user
  #
  # overridden to:
  #   respond_with resource, :location => spree.login_path
  #
  def create
    self.resource = resource_class.send_reset_password_instructions(params[resource_name], current_store)

    if resource.errors.empty?
      set_flash_message(:notice, :send_instructions) if is_navigational_format?
      respond_with resource, location: spree.login_path
    else
      respond_with_navigational(resource) { render :new }
    end
  end

  # Devise::PasswordsController allows for blank passwords.
  # Silly Devise::PasswordsController!
  # Fixes spree/spree#2190.
  def update
    if params[:spree_user][:password].blank?
      self.resource = resource_class.new
      resource.reset_password_token = params[:spree_user][:reset_password_token]
      set_flash_message(:error, :cannot_be_blank)
      render :edit
    else
      super
    end
  end

  protected

  def translation_scope
    'devise.user_passwords'
  end

  def new_session_path(resource_name)
    spree.send("new_#{resource_name}_session_path")
  end

  private

  def accurate_title
    Spree.t(:reset_password)
  end
end
