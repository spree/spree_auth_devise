class AddAccountTypeToSpreeUsers < ActiveRecord::Migration
  def change
    remove_column Spree::User, :account_type
    add_column Spree::User, :account_type, :integer, :default => 1
  end
end
