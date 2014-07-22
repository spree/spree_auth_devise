require 'spree/core/validators/email'
Spree::CheckoutController.class_eval do
  before_filter :check_authorization
  before_filter :check_registration, :except => [:registration, :update_registration]

  def registration
    @user = Spree::User.new
  end

  def update_registration
    current_order.update_column(:email, params[:order][:email])
    if Spree::User.find_by(email: params[:order][:email]) != nil
      render_email_error :email_already_registered
    elsif !EmailValidator.new(:attributes => current_order.attributes).valid?(current_order.email)
      render_email_error :email_is_invalid
    else
      redirect_to checkout_path
    end
  end

  def render_email_error (error_name)
    flash[:registration_error] = t(error_name, :scope => [:errors, :messages])
    @user = Spree::User.new
    render 'registration'
  end

  private
    def order_params
      if params[:order]
        params.require(:order).permit(:email)
      else
        {}
      end
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
      return if spree_current_user or current_order.email
      store_location
      redirect_to spree.checkout_registration_path
    end

    # Overrides the equivalent method defined in Spree::Core.  This variation of the method will ensure that users
    # are redirected to the tokenized order url unless authenticated as a registered user.
    def completion_route
      return order_path(@order) if spree_current_user
      spree.token_order_path(@order, @order.guest_token)
    end
end
