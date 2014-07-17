Spree::Admin::OrdersController.class_eval do
  before_filter :check_authorization

  private
    def not_load_order_action
      [:index, :new]
    end

    def check_authorization
      action = params[:action].to_sym
      if not_load_order_action.include?(action)
        authorize! :index, Spree::Order
      else
        load_order
        session[:access_token] ||= params[:token]
        resource = @order || Spree::Order.new
        authorize! action, resource, session[:access_token]
      end
    end
end
