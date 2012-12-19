# encoding: UTF-8

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_auth_devise'
  s.version     = '1.0.0'
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
  s.add_dependency 'devise', '~> 2.0.4'
  s.add_dependency 'cancan', '= 1.6.8'
end
