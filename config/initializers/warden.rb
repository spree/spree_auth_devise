# Merges users orders to their account after sign in and sign up.
Warden::Manager.after_set_user except: :fetch do |user, auth, opts|
  if auth.cookies.signed[:guest_token].present?
    if user.is_a?(Spree::User)
      Spree::Order.where(email: user.email, guest_token: auth.cookies.signed[:guest_token], user_id: nil).each do |order|
        order.associate_user!(user)
      end
    end
  end
end

Warden::Manager.before_logout do |user, auth, opts|
  auth.cookies.delete :guest_token
end
