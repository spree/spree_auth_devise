require 'devise'
require 'devise-encryptable'

require_relative 'configuration'

module Spree
  module Auth
    class Engine < Rails::Engine
      isolate_namespace Spree
      engine_name 'spree_auth'

      initializer "spree.auth.environment", before: :load_config_initializers do |_app|
        Spree::Auth::Config = Spree::Auth::Configuration.new
      end

      initializer "spree_auth_devise.set_user_class", after: :load_config_initializers do
        Spree.user_class = 'Spree::User'
      end

      initializer "spree_auth_devise.check_secret_token" do
        if Spree::Auth.default_secret_key == Devise.secret_key
          puts "[WARNING] You are not setting Devise.secret_key within your application!"
          puts "You must set this in config/initializers/devise.rb. Here's an example:"
          puts " "
          puts %{Devise.secret_key = "#{SecureRandom.hex(50)}"}
        end
      end

      def self.activate
        Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
          Rails.configuration.cache_classes ? require(c) : load(c)
        end
        if Spree::Auth::Engine.backend_available?
          Dir.glob(File.join(File.dirname(__FILE__), "../../controllers/backend/*/*/*_decorator*.rb")) do |c|
            Rails.configuration.cache_classes ? require(c) : load(c)
          end
        end
        if Spree::Auth::Engine.frontend_available?
          Dir.glob(File.join(File.dirname(__FILE__), "../../controllers/frontend/**/*_decorator*.rb")) do |c|
            Rails.configuration.cache_classes ? require(c) : load(c)
          end
        end
        if Spree::Auth::Engine.api_available?
          Dir.glob(File.join(File.dirname(__FILE__), "../../controllers/api/**/*_decorator*.rb")) do |c|
            Rails.configuration.cache_classes ? require(c) : load(c)
          end
        end
        ApplicationController.send :include, Spree::AuthenticationHelpers
      end

      def self.api_available?
        @@api_available ||= ::Rails::Engine.subclasses.map(&:instance).map{ |e| e.class.to_s }.include?('Spree::Api::Engine')
      end

      def self.backend_available?
        @@backend_available ||= ::Rails::Engine.subclasses.map(&:instance).map{ |e| e.class.to_s }.include?('Spree::Backend::Engine')
      end

      def self.frontend_available?
        @@frontend_available ||= Gem::Specification.find_all_by_name('spree_frontend').any?
      end

      def self.api_available?
        @@api_available ||= ::Rails::Engine.subclasses.map(&:instance).map{ |e| e.class.to_s }.include?('Spree::Api::Engine')
      end

      def self.emails_available?
        @@emails_available ||= ::Rails::Engine.subclasses.map(&:instance).map{ |e| e.class.to_s }.include?('Spree::Emails::Engine')
      end

      if backend_available?
        paths["app/controllers"] << "lib/controllers/backend"
        paths["app/views"] << "lib/views/backend"
      end

      if frontend_available?
        paths["app/controllers"] << "lib/controllers/frontend"
        paths["app/views"] << "lib/views/frontend"
      end

      if api_available?
        paths["app/controllers"] << "lib/controllers/api"
      end

      if emails_available?
        paths["app/views"] << "lib/views/emails"
        paths["app/mailers"] << "lib/mailers"
      end

      config.to_prepare &method(:activate).to_proc
    end
  end
end
