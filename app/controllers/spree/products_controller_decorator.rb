Spree::ProductsController.class_eval do
  rescue_from CanCan::AccessDenied, :with => :render_404

  private
    def load_product
      @product = Spree::Product.find_by_permalink!(params[:id])
      if !@product.deleted? && (@product.available_on.nil? || @product.available_on.future?)
        # Allow admins to view any yet to be available products
        raise CanCan::AccessDenied unless spree_current_user && spree_current_user.has_spree_role?(:admin)
      end
    end
end

