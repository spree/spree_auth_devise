# This migration comes from spree (originally 20111219205902)
class AddDefaultTaxZone < ActiveRecord::Migration
  def change
    add_column :spree_zones, :default_tax, :boolean, :default => false
  end
end
