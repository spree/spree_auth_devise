module Spree
  module Auth
    module PermittedAttributes
      ATTRIBUTES = [:spree_user_attributes]

      mattr_reader *ATTRIBUTES

      @@spree_user_attributes = [:email, :password, :password_confirmation]
    end
  end
end
