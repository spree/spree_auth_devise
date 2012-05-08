# This migration comes from spree (originally 20091211203813)
class ShipAddressIdForCheckouts < ActiveRecord::Migration
  def change
    add_column :checkouts, :ship_address_id, :integer
  end
end
