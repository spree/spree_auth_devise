# This migration comes from spree (originally 20110418151136)
class EligibleForAdjustments < ActiveRecord::Migration
  def change
    add_column :adjustments, :eligible, :boolean, :default => true
  end
end
