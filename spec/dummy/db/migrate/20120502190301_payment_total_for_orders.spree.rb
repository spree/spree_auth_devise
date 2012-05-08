# This migration comes from spree (originally 20100813185745)
class PaymentTotalForOrders < ActiveRecord::Migration
  def change
    add_column :orders, :payment_total, :decimal, :precision => 8, :scale => 2, :default => 0.0
  end
end
