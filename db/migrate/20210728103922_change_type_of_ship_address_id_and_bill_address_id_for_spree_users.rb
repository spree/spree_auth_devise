class ChangeTypeOfShipAddressIdAndBillAddressIdForSpreeUsers < ActiveRecord::Migration[4.2]
  def change
    change_table(:spree_users) do |t|
      t.change :ship_address_id, :bigint
      t.change :bill_address_id, :bigint
    end
  end
end
