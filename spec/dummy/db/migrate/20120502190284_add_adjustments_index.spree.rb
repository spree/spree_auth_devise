# This migration comes from spree (originally 20100301163454)
class AddAdjustmentsIndex < ActiveRecord::Migration
  def change
    add_index :adjustments, :order_id
  end
end

