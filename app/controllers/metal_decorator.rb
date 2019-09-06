# For the API
module MetalDecorator
  def spree_current_user
    @spree_current_user ||=  if defined? env
                               env['warden'].user
                             else
                               request.env['warden'].user
                             end
  end
end

ActionController::Metal.prepend(MetalDecorator)
