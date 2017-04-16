class AddConfirmationToUser < ActiveRecord::Migration
  def change
    add_column :spree_users, :confirmation_token, :string
    add_column :spree_users, :confirmed_at, :datetime
    add_column :spree_users, :confirmation_sent_at, :datetime
    add_column :spree_users, :unconfirmed_email, :string # Only if using reconfirmable

  end
    # add_index :users, :confirmation_token,   unique: true
end
