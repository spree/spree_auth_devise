# encoding: UTF-8

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_auth_devise'
  s.version     = '4.1.0.alpha'
  s.summary     = 'Provides authentication and authorization services for use with Spree by using Devise and CanCan.'
  s.description = s.summary

  s.required_ruby_version = '>= 2.2.7'

  s.author      = 'Sean Schofield'
  s.email       = 'sean@spreecommerce.com'
  s.homepage    = 'https://spreecommerce.org'
  s.license     = 'BSD-3-Clause'

  s.files        = `git ls-files`.split("\n")
  s.test_files   = `git ls-files -- spec/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'devise', '~> 4.7'
  s.add_dependency 'devise-encryptable', '0.2.0'

  spree_version = '>= 4.1.0.alpha', '< 5.0'
  s.add_dependency 'spree_core', spree_version
  s.add_dependency 'spree_extension'
  s.add_dependency 'deface', '~> 1.0'

  s.add_development_dependency 'capybara'
  s.add_development_dependency 'capybara-screenshot'
  s.add_development_dependency 'coffee-rails', '~> 4.2'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'database_cleaner', '~> 1.5'
  s.add_development_dependency 'email_spec', '~> 2.1'
  s.add_development_dependency 'factory_bot', '~> 4.7'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'launchy'
  s.add_development_dependency 'mysql2'
  s.add_development_dependency 'pg'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'puma'
  s.add_development_dependency 'rails-controller-testing'
  s.add_development_dependency 'rspec-rails', '~> 4.0.0.beta2'
  s.add_development_dependency 'shoulda-matchers', '~> 4.2'
  s.add_development_dependency 'simplecov', '~> 0.12'
  s.add_development_dependency 'spree_backend', spree_version
  s.add_development_dependency 'spree_frontend', spree_version
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'appraisal'
end
