module Spree::StoreControllerDecorator
  def account_link
    render partial: 'spree/shared/link_to_account'
    fresh_when(spree_current_user)
  end
end
Spree::StoreController.prepend(Spree::StoreControllerDecorator)
