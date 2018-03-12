# For the API
ActionController::Metal.class_eval do
  def spree_current_user
    @spree_current_user ||=  if defined? env
                               env['warden'].user
                             else
                               request.env['warden'].user
                             end
  end
end
