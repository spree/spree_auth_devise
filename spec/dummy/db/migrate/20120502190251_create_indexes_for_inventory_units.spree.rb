# This migration comes from spree (originally 20090904192342)
class CreateIndexesForInventoryUnits < ActiveRecord::Migration
  def change
    add_index :inventory_units, :variant_id
    add_index :inventory_units, :order_id
  end
end
