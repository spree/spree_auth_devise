# This migration comes from spree (originally 20100929151905)
class RenameFrozenToLocked < ActiveRecord::Migration
  def change
    rename_column :adjustments, :frozen, :locked
  end
end
