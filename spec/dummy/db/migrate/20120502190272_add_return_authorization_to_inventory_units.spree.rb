# This migration comes from spree (originally 20100113090919)
class AddReturnAuthorizationToInventoryUnits < ActiveRecord::Migration
  def change
    add_column :inventory_units, :return_authorization_id, :integer
  end
end
