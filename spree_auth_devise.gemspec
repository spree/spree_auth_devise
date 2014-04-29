# encoding: UTF-8

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_auth_devise'
  s.version     = '1.3.0'
  s.summary     = 'Provides authentication and authorization services for use with Spree by using Devise and CanCan.'
  s.description = 'Required dependency for Spree'

  s.required_ruby_version = '>= 1.8.7'
  s.author      = 'Sean Schofield'
  s.email       = 'sean@spreecommerce.com'
  s.homepage    = 'http://spreecommerce.com'

  s.files        = Dir['LICENSE', 'README.md', 'app/**/*', 'config/**/*', 'lib/**/*', 'db/**/*']
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core'
  s.add_dependency 'devise', '~> 2.2.3'
  s.add_dependency 'devise-encryptable', '0.1.2'
  s.add_dependency 'cancan', '~> 1.6.7'
  s.add_development_dependency 'rspec-rails', '~> 2.12.2'
  s.add_development_dependency 'factory_girl_rails', '1.7.0'
  s.add_development_dependency 'email_spec', '~> 1.2.1'
  s.add_development_dependency 'capybara', '~> 2.1.0'
  s.add_development_dependency 'database_cleaner', '0.9.1'
  s.add_development_dependency 'selenium-webdriver', '2.35.1'
  s.add_development_dependency 'launchy'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'debugger'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'pg'
  s.add_development_dependency 'shoulda-matchers', '~> 1.0.0'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'mysql2'
end
