# This migration comes from spree (originally 20100811205836)
class DropOrderToken < ActiveRecord::Migration
  def up
    remove_column :orders, :token
  end

  def down
    add_column :orders, :token, :string
  end
end
