# This migration comes from spree (originally 20101026185022)
class UpdateOrderState < ActiveRecord::Migration
  def up
    Spree::Order.table_name = 'orders'

    Spree::Order.all.map(&:update!)

    Spree::Order.table_name = 'spree_orders'
  end

  def down
  end
end
