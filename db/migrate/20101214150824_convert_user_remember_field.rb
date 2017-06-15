if ActiveRecord.gem_version >= Gem::Version.new('5.0')
  class ConvertUserRememberField < ActiveRecord::Migration[4.2]; end
else
  class ConvertUserRememberField < ActiveRecord::Migration; end
end
ConvertUserRememberField.class_eval do
  def up
    remove_column :spree_users, :remember_created_at
    add_column :spree_users, :remember_created_at, :datetime
  end

  def down
    remove_column :spree_users, :remember_created_at
    add_column :spree_users, :remember_created_at, :string
  end
end
