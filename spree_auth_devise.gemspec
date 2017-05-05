# encoding: UTF-8

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_auth_devise'
  s.version     = '3.2.1.beta'
  s.summary     = 'Provides authentication and authorization services for use with Spree by using Devise and CanCan.'
  s.description = s.summary

  s.required_ruby_version = '>= 2.4.0'

  s.author      = 'Sean Schofield'
  s.email       = 'sean@spreecommerce.com'
  s.homepage    = 'http://spreecommerce.com'
  s.license     = %q{BSD-3}

  s.files        = `git ls-files`.split("\n")
  s.test_files   = `git ls-files -- spec/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'devise'
  s.add_dependency 'devise-encryptable'

  spree_version = '>= 3.1.0', '< 4.0'
  s.add_dependency 'spree_core', spree_version

  s.add_development_dependency 'capybara', '~> 2.7'
  s.add_development_dependency 'capybara-screenshot'
  s.add_development_dependency 'coffee-rails', '~> 4.2'
  s.add_development_dependency 'database_cleaner', '~> 1.5'
  s.add_development_dependency 'email_spec', '~> 2.1'
  s.add_development_dependency 'factory_girl', '~> 4.7'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'launchy'
  s.add_development_dependency 'mysql2'
  s.add_development_dependency 'pg'
  s.add_development_dependency 'poltergeist', '~> 1.6'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rspec-rails', '~> 3.5'
  s.add_development_dependency 'shoulda-matchers', '~> 3.1'
  s.add_development_dependency 'simplecov', '~> 0.12'
  s.add_development_dependency 'spree_backend', spree_version
  s.add_development_dependency 'spree_frontend', spree_version
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rails-controller-testing'
end
