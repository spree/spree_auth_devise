source 'http://rubygems.org'

gem 'devise', '~> 2.1.2'
gem 'devise-encryptable'

gem 'json'
gem 'sqlite3'
gem 'mysql2'
gem 'pg'
gem 'multi_json', '1.2.0'
# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '~> 3.2'
  gem 'coffee-rails', '~> 3.2'
end

group :test do
  gem 'rspec-rails', '~> 2.12.0'
  gem 'factory_girl_rails', '~> 1.7.0'
  gem 'email_spec', '~> 1.2.1'

  gem 'ffaker'
  gem 'shoulda-matchers', '~> 1.4.2'
  gem 'capybara', '1.1.3'
  gem 'database_cleaner', '0.9.1'
  gem 'launchy'
 # gem 'debugger'
end

if ENV['USE_LOCAL_SPREE']
  gem 'spree', :path => '~/Sites/gems/spree'
else
  gem 'spree', :git => 'git://github.com/spree/spree', :branch => '1-2-stable'
end

gemspec



