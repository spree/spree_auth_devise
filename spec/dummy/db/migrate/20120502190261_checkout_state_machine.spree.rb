# This migration comes from spree (originally 20091126190904)
class CheckoutStateMachine < ActiveRecord::Migration
  def change
    add_column :checkouts, :state, :string
  end
end
