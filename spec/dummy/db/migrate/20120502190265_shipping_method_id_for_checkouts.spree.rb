# This migration comes from spree (originally 20091212161118)
class ShippingMethodIdForCheckouts < ActiveRecord::Migration
  def change
    add_column :checkouts, :shipping_method_id, :integer
  end
end
