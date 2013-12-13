require 'devise-encryptable'

module Spree
  module Auth
    class Engine < Rails::Engine
      isolate_namespace Spree
      engine_name 'spree_auth'

      initializer "spree.auth.environment", :before => :load_config_initializers do |app|
        Spree::Auth::Config = Spree::AuthConfiguration.new
      end

      def self.activate
        Dir.glob(File.join(File.dirname(__FILE__), "../../../app/**/*_decorator*.rb")) do |c|
          Rails.configuration.cache_classes ? require(c) : load(c)
        end

        ApplicationController.send :include, Spree::AuthenticationHelpers
      end

      initializer "spree_auth_devise.set_user_class", :after => :load_config_initializers do
        Spree.user_class = "Spree::User"
      end

      initializer "spree_auth_devise.check_secret_token" do
        if Spree::Auth.default_secret_key == Devise.secret_key
          puts "[WARNING] You are not setting Devise.secret_token within your application!"
          puts "You must set this in config/initializers/devise.rb. Here's an example:"
          puts " "
          puts %Q{Devise.secret_token = "#{SecureRandom.hex(50)}"}
        end
      end

      config.to_prepare &method(:activate).to_proc
    end
  end
end
