# Merges users orders to their account after sign in and sign up.
Warden::Manager.after_set_user except: :fetch do |user, auth, opts|
  if auth.cookies.signed[:guest_token].present?
    Spree::Order.where(guest_token: auth.cookies.signed[:guest_token], user_id: nil).update_all(user_id: user.id, created_by_id: user.id)
  end
end
