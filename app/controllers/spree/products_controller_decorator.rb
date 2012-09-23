Spree::ProductsController.class_eval do
  rescue_from CanCan::AccessDenied, :with => :render_404

  private
    def load_product
      @product = Spree::Product.find_by_permalink!(params[:id])
      if !@product.deleted? && !@product.available?
        # Allow admins to view any yet to be available products
        raise CanCan::AccessDenied unless spree_current_user && spree_current_user.spree_admin?
      end
    end
end

