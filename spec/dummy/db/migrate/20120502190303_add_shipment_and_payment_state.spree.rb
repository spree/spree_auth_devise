# This migration comes from spree (originally 20100817152723)
class AddShipmentAndPaymentState < ActiveRecord::Migration
  def change
    add_column :orders, :shipment_state, :string
    add_column :orders, :payment_state, :string
  end
end