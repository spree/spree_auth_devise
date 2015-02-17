# Spree Auth (Devise)

[![Build Status](https://secure.travis-ci.org/spree/spree_auth_devise.png?branch=master)](https://travis-ci.org/spree/spree_auth_devise)
[![Code Climate](https://codeclimate.com/github/spree/spree_auth_devise.png)](https://codeclimate.com/github/spree/spree_auth_devise)

Provides authentication services for Spree, using the Devise gem.

## Installation

At one stage in the past, this used to be the auth component for Spree. If that's the feature that you're now finding lacking from Spree, that's easily fixed.

Just add this line to your `Gemfile`:
```ruby
gem 'spree_auth_devise', github: 'spree/spree_auth_devise', branch: 'master'
```

Please ensure you're using the correct branch of `spree_auth_devise` relative to your version of Spree.

Spree 1.3.x or 1-3-stable:
```ruby
gem 'spree_auth_devise', :github => 'spree/spree_auth_devise', :branch => '1-3-stable'
```

Spree 1.2.x or 1-2-stable:
```ruby
gem 'spree_auth_devise', :github => 'spree/spree_auth_devise', :branch => '1-2-stable'
```

Then run `bundle install`. Authentication will then work exactly as it did in previous versions of Spree.

If you're installing this in a new Spree 1.2+ application, you'll need to install and run the migrations with

    bundle exec rake spree_auth:install:migrations
    bundle exec rake db:migrate
    bundle exec rails g spree:auth:install

and then, run this command in order to set up the admin user for the application.

    bundle exec rake spree_auth:admin:create

## Configuration

### Confirmable

To enable Devise's Confirmable module, which will send the user an email with a link to confirm their account, you must do the following:

* Add this line to an initializer in your Rails project (typically `config/initializers/spree.rb`):
```ruby
Spree::Auth::Config[:confirmable] = true
```

* Add a Devise initializer to your Rails project (typically `config/initializers/devise.rb`):
```ruby
Devise.setup do |config|
  # Required so users don't lose their carts when they need to confirm.
  config.allow_unconfirmed_access_for = 1.days

  # Fixes the bug where Confirmation errors result in a broken page.
  config.router_name = :spree

  # Add any other devise configurations here, as they will override the defaults provided by spree_auth_devise.
end
```

## Using in an existing Rails application

If you are installing Spree inside of a host application in which you want your own permission setup, you can do this using spree_auth_devise's register_ability method.

First create your own CanCan Ability class following the CanCan documentation.

For example: app/models/your_ability_class.rb

```ruby
class YourAbilityClass
  include CanCan::Ability

  def initialize user
    # direct permissions
     can :create, SomeRailsObject

     # or permissions by group
     if spree_user.has_spree_role? "admin"
       can :create, SomeRailsAdminObject
     end
   end
end
```

Then register your class in your spree initializer: config/initializers/spree.rb
```ruby
Spree::Ability.register_ability(YourAbilityClass)
```

Inside of your host application you can then use CanCan like you normally would.
```ruby
<% if can? :show SomeRailsObject %>

<% end %>
```

### Adding Permissions to Gems

This methodology can also be used by gems that extend spree and want/need to add permissions.

## Testing

You need to do a quick one-time creation of a test application and then you can use it to run the tests.

    bundle exec rake test_app

Then run the rspec tests.

    bundle exec rake spec

If everything doesn't pass on your machine (using Ruby (1.9.3 or 2.0.0) and (MySQL or PostgreSQL or SQLite3)) then we would consider that a bug. Please file a bug report on the issues page for this project with your test output and we will investigate it.
