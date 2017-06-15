if ActiveRecord.gem_version >= Gem::Version.new('5.0')
  class AddConfirmableToUsers < ActiveRecord::Migration[4.2]; end
else
  class AddConfirmableToUsers < ActiveRecord::Migration; end
end
AddConfirmableToUsers.class_eval do
  def change
    add_column :spree_users, :confirmation_token, :string
    add_column :spree_users, :confirmed_at, :datetime
    add_column :spree_users, :confirmation_sent_at, :datetime
  end
end
