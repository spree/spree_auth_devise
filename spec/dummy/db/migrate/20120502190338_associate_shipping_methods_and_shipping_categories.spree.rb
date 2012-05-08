# This migration comes from spree (originally 20120105193911)
class AssociateShippingMethodsAndShippingCategories < ActiveRecord::Migration
  def change
    change_table :spree_shipping_methods do |t|
      t.references :shipping_category
    end
  end
end
