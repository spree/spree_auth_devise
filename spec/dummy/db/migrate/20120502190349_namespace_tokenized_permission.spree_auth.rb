# This migration comes from spree_auth (originally 20111007143030)
class NamespaceTokenizedPermission < ActiveRecord::Migration
  def change
    rename_table :tokenized_permissions, :spree_tokenized_permissions
  end
end
