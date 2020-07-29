require 'spree/core/validators/email' if Spree.version.to_f < 3.5
module Spree::CheckoutControllerDecorator
  def self.prepended(base)
    base.before_action :check_authorization
    base.before_action :check_registration, except: [:registration, :update_registration]
  end

  def registration
    @user = Spree.user_class.new 
    @title = Spree.t(:registration)
  end

  def update_registration
    if order_params[:email] =~ Devise.email_regexp && current_order.update_attribute(:email, order_params[:email])
      redirect_to spree.checkout_state_path(:address)
    else
      flash[:error] = t(:email_is_invalid, scope: [:errors, :messages])
      @user = Spree.user_class.new
      render 'registration'
    end
  end

  private

  def order_params
    params[:order].present? ? params.require(:order).permit(:email) : {}
  end

  def skip_state_validation?
    %w(registration update_registration).include?(params[:action])
  end

  def check_authorization
    authorize!(:edit, current_order, cookies.signed[:guest_token])
  end

  # Introduces a registration step whenever the +registration_step+ preference is true.
  def check_registration
    return unless Spree::Auth::Config[:registration_step]
    return if spree_current_user || current_order.email
    store_location
    redirect_to spree.checkout_registration_path
  end
end
Spree::CheckoutController.prepend(Spree::CheckoutControllerDecorator)
