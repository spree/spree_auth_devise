module Spree::Auth::Admin::Orders::CustomerDetailsControllerDecorator

  def self.prepended(base)
    base.before_action :check_authorization
  end

  private

  def check_authorization
    load_order
    session[:access_token] ||= params[:token]

    resource = @order
    action = params[:action].to_sym
    action = :edit if action == :show # show route renders :edit for this controller

    authorize! action, resource, session[:access_token]
  end
end
Spree::Admin::Orders::CustomerDetailsController.prepend(Spree::Auth::Admin::Orders::CustomerDetailsControllerDecorator)
