Spree::Admin::BaseController.class_eval do
  rescue_from CanCan::AccessDenied, with: :unauthorized
end
