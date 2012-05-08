# This migration comes from spree (originally 20100427121301)
class AddDisplayToPaymentMethods < ActiveRecord::Migration
  def change
    add_column :payment_methods, :display, :string, :default => nil
  end
end
