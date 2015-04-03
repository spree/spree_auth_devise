class AddAccountTypeToSpreeUsers < ActiveRecord::Migration
  def change
    add_column Spree::User, :account_type, :integer, :default => 1
  end
end
