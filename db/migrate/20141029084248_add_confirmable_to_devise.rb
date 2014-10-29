class AddConfirmableToDevise < ActiveRecord::Migration
  def self.up
    add_column Spree::User, :confirmation_token, :string
    add_column Spree::User, :confirmed_at,       :datetime
    add_column Spree::User, :confirmation_sent_at , :datetime
    add_column Spree::User, :unconfirmed_email, :string

    add_index  Spree::User, :confirmation_token, :unique => true
  end
  def self.down
    remove_index  Spree::User, :confirmation_token

    remove_column Spree::User, :unconfirmed_email
    remove_column Spree::User, :confirmation_sent_at
    remove_column Spree::User, :confirmed_at
    remove_column Spree::User, :confirmation_token
  end
end