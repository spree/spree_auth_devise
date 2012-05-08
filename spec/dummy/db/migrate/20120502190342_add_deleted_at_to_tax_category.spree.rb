# This migration comes from spree (originally 20120203153759)
class AddDeletedAtToTaxCategory < ActiveRecord::Migration
  def change
    add_column :spree_tax_categories, :deleted_at, :datetime
  end
end
