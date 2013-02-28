if defined?(Spree::Admin::BaseController)
  require File.expand_path('../../base_controller_decorator', __FILE__)
  Spree::Admin::BaseController.class_eval do
    protected
      def model_class
        const_name = "Spree::#{controller_name.classify}"
        if Object.const_defined?(const_name)
          return const_name.constantize
        end
        nil
      end
  end
end
