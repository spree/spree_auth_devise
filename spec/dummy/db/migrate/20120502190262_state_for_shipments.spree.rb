# This migration comes from spree (originally 20091209153045)
class StateForShipments < ActiveRecord::Migration
  def change
    add_column :shipments, :state, :string
  end
end
