Spree::Admin::Orders::CustomerDetailsController.class_eval do
  before_action :check_authorization

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
