# This migration comes from spree (originally 20100528155333)
class IndexForShipmentsNumber < ActiveRecord::Migration
  def change
    add_index :shipments, :number
  end
end
