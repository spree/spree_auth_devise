# This migration comes from spree (originally 20100901171814)
class ChangeGuestFlagToAnonymous < ActiveRecord::Migration
  def change
    rename_column :users, :guest, :anonymous
  end
end
