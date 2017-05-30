if ActiveRecord.gem_version >= Gem::Version.new('5.0')
  class AddDeletedAtToUsers < ActiveRecord::Migration[4.2]; end
else
  class AddDeletedAtToUsers < ActiveRecord::Migration; end
end
AddDeletedAtToUsers.class_eval do
  def change
    add_column :spree_users, :deleted_at, :datetime
    add_index :spree_users, :deleted_at
  end
end
