module Spree
  module Auth
    module Generators
      class InstallGenerator < Rails::Generators::Base
        class_option :migrate, type: :boolean, default: true, banner: 'Migrate the database'

        def self.source_paths
          paths = superclass.source_paths
          paths << File.expand_path('../templates', __FILE__)
          paths.flatten
        end

        def add_javascripts
          append_file 'vendor/assets/javascripts/spree/frontend/all.js', "//= require spree/frontend/spree_auth\n"
        end

        def generate_devise_key
          return if ENV['CI']
          template 'config/initializers/devise.rb', 'config/initializers/devise.rb'
        end

        def add_migrations
          run 'bundle exec rake railties:install:migrations FROM=spree_auth_devise'
        end

        def run_migrations
         if options[:migrate]
           run 'bundle exec rake db:migrate VERBOSE=false'
         else
           puts "Skiping rake db:migrate, don't forget to run it!"
         end
        end
      end
    end
  end
end
