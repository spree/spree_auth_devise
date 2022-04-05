module Spree::Auth::Admin::ResourceControllerDecorator
  def self.prepended(base)
    base.rescue_from CanCan::AccessDenied, with: :unauthorized
  end
end
Spree::Admin::ResourceController.prepend(Spree::Auth::Admin::ResourceControllerDecorator)
