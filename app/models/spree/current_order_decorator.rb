Spree::Core::CurrentOrder.module_eval do
  def after_save_new_order
    # make sure the user has permission to access the order (if they are a guest)
    return if spree_current_user
    session[:access_token] = @current_order.token
  end
end
