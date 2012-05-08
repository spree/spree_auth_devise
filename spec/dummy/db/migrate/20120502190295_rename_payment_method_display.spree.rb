# This migration comes from spree (originally 20100624123336)
class RenamePaymentMethodDisplay < ActiveRecord::Migration
  def change
    rename_column :payment_methods, :display, :display_on
  end
end
