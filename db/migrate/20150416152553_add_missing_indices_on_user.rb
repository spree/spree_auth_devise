class AddMissingIndicesOnUser < ActiveRecord::Migration
  def change
    add_index :spree_users, :bill_address_id
    add_index :spree_users, :ship_address_id
  end
end
