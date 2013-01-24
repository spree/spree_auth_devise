if defined?(Spree::Admin::BaseController)
  require File.expand_path('../../base_controller_decorator', __FILE__)
  Spree::Admin::BaseController.class_eval do
    protected
      def model_class
        "Spree::#{controller_name.classify}".constantize
      end
  end
end
