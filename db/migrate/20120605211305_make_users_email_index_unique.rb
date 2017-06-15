if ActiveRecord.gem_version >= Gem::Version.new('5.0')
  class MakeUsersEmailIndexUnique < ActiveRecord::Migration[4.2]; end
else
  class MakeUsersEmailIndexUnique < ActiveRecord::Migration; end
end
MakeUsersEmailIndexUnique.class_eval do
  def up
    add_index "spree_users", ["email"], name: "email_idx_unique", unique: true
  end

  def down
    remove_index "spree_users", name: "email_idx_unique"
  end
end
