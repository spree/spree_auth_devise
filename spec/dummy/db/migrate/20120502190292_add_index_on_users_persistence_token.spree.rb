# This migration comes from spree (originally 20100528185820)
class AddIndexOnUsersPersistenceToken < ActiveRecord::Migration
  def change
    add_index :users, :persistence_token
  end
end
