# This migration comes from spree (originally 20100121160010)
class CreditcardIdForCreditcardTxns < ActiveRecord::Migration
  def change
    add_column :creditcard_txns, :creditcard_id, :integer
  end
end
