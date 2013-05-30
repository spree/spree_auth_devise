if defined?(Spree::Admin::OrdersController)
  Spree::Admin::OrdersController.class_eval do
    before_filter :check_authorization

    private
      def check_authorization
        action = params[:action].to_sym
        if action == :index
          authorize! :index, Spree::Order
        else
          load_order
          session[:access_token] ||= params[:token]
          resource = @order || Spree::Order.new
          authorize! action, resource, session[:access_token]
        end
      end
  end
end
