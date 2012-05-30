namespace :spree_auth do
  namespace :admin do
    desc "Create admin username and password"
    task :create => :environment do
      require File.join(File.dirname(__FILE__), '..', '..', 'db', 'default', 'users.rb')
      puts "Done!"
    end
  end
end
