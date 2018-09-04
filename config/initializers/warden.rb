# Merges users orders to their account after sign in and sign up.
Warden::Manager.after_set_user except: :fetch do |user, auth, _opts|
  guest_token = auth.cookies.signed[:guest_token]
  token       = auth.cookies.signed[:token]

  if token.present? && user.is_a?(Spree::User)
    Spree::Order.incomplete.where(token: token, user_id: nil).each do |order|
      order.associate_user!(user)
    end
  elsif guest_token.present? && user.is_a?(Spree::User)
    Spree::Order.incomplete.where(guest_token: guest_token, user_id: nil).each do |order|
      order.associate_user!(user)
    end
  end
end

Warden::Manager.before_logout do |_user, auth, _opts|
  auth.cookies.delete(:guest_token)
  auth.cookies.delete(:token)
end
