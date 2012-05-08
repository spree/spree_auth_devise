# This migration comes from spree (originally 20100816212146)
class ShippingMethodIdForOrders < ActiveRecord::Migration
  def change
    add_column :orders, :shipping_method_id, :integer
  end
end
