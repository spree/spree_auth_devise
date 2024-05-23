source 'https://rubygems.org'

gem 'rails-controller-testing'
gem 'spree', github: 'spree/spree', branch: 'main'
gem 'spree_backend', github: 'spree/spree_backend', branch: 'main'
gem 'spree_emails', github: 'spree/spree', branch: 'main'
gem 'spree_frontend', github: 'spree/spree_legacy_frontend', branch: 'main'

platforms :ruby do
  if ENV['DB'] == 'mysql'
    gem 'mysql2'
  elsif ENV['DB'] == 'postgres'
    gem 'pg'
  else
    gem 'sqlite3', '~> 2.0'
  end
end

gem 'pry'
gemspec
