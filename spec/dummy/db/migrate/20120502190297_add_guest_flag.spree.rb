# This migration comes from spree (originally 20100811163637)
class AddGuestFlag < ActiveRecord::Migration
  def change
    add_column :users, :guest, :boolean
  end
end
