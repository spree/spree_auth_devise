class AddStoreGroupToSpreeUsers < ActiveRecord::Migration
  def change
    add_column(:spree_users, :store_group, :string) unless Spree::User.column_names.include?('store_group')
  end
end
