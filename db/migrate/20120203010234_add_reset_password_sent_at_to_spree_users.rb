if ActiveRecord.gem_version >= Gem::Version.new('5.0')
  class AddResetPasswordSentAtToSpreeUsers < ActiveRecord::Migration[4.2]; end
else
  class AddResetPasswordSentAtToSpreeUsers < ActiveRecord::Migration; end
end
AddResetPasswordSentAtToSpreeUsers.class_eval do
  def change
    Spree::User.reset_column_information
    unless Spree::User.column_names.include?("reset_password_sent_at")
      add_column :spree_users, :reset_password_sent_at, :datetime
    end
  end
end
