namespace :spree_auth do
  desc "Create admin username and password"
  task :seed => :environment do
    require File.join(File.dirname(__FILE__), '..', '..', 'db', 'default', 'users.rb')
    puts "Done!"
  end
end
