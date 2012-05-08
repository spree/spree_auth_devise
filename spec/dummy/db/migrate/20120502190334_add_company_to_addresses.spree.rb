# This migration comes from spree (originally 20111215032408)
class AddCompanyToAddresses < ActiveRecord::Migration
  def change
    add_column :spree_addresses, :company, :string
  end
end
