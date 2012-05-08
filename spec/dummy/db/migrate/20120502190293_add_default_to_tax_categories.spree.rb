# This migration comes from spree (originally 20100605152042)
class AddDefaultToTaxCategories < ActiveRecord::Migration
  def change
    add_column :tax_categories, :is_default, :boolean, :default => false
  end
end
