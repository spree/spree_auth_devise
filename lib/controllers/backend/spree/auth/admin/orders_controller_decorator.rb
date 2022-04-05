module Spree::Auth::Admin::OrdersControllerDecorator

  def self.prepended(base)
    base.before_action :check_authorization
  end

  private

  def load_order_action
    [:edit, :update, :cancel, :resume, :approve, :resend, :open_adjustments, :close_adjustments, :cart]
  end

  def check_authorization
    action = params[:action].to_sym
    if load_order_action.include?(action)
      load_order
      session[:access_token] ||= params[:token]
      resource = @order || Spree::Order.new
      authorize! action, resource, session[:access_token]
    else
      authorize! :index, Spree::Order
    end
  end
end
Spree::Admin::OrdersController.prepend(Spree::Auth::Admin::OrdersControllerDecorator)
