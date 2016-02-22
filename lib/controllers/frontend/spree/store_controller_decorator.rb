Spree::StoreController.class_eval do
  def account_link
    render partial: 'spree/shared/link_to_account'
    fresh_when(spree_current_user)
  end
end
