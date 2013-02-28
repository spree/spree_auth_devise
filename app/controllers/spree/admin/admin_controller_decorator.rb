if defined?(Spree::Admin::BaseController)
  require File.expand_path('../../base_controller_decorator', __FILE__)
  Spree::Admin::BaseController.class_eval do
    protected
      def model_class
        const_name = controller_name.classify
        if Spree.const_defined?(const_name)
          return "Spree::#{const_name}".constantize
        end
        nil
      end
  end
end
