# This migration comes from spree (originally 20110111122537)
class AddPositionToOptionTypes < ActiveRecord::Migration
  def change
    add_column :option_types, :position, :integer, :null => false, :default => 0
  end
end
