# Spree Auth (Devise)

[![Build Status](https://travis-ci.org/spree/spree_auth_devise.svg?branch=master)](https://travis-ci.org/spree/spree_auth_devise)
[![Code Climate](https://codeclimate.com/github/spree/spree_auth_devise/badges/gpa.svg)](https://codeclimate.com/github/spree/spree_auth_devise)

Provides authentication services for [Spree](https://spreecommerce.org), using the [Devise](https://github.com/plataformatec/devise) gem.


## Installation

1. Add this extension to your Gemfile with this line:

  ```ruby
  gem 'spree_auth_devise'
  ```
  
  if you run into any version-mismatch problems please run `bundle update`

2. Install the gem using Bundler:
  ```ruby
  bundle install
  ```

3. Copy & run migrations
  ```ruby
  bundle exec rails g spree:auth:install
  ```

## Upgrading from Spree 3.0 to 3.1

If you're upgrading from 3.0 to 3.1 you need to rerun the installer to copy new asset files (javascripts)

```ruby
bundle exec rails g spree:auth:install
```

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

### Lockable

To enable Devise's Lockable module, which will allow user accounts to be locked after failed retry, you can follow instructions below:

* Add this line to an initializer in your Rails project (typically `config/initializers/spree.rb`)
```ruby
Spree::Auth::Config[:lockable] = true
```

* Add a Devise initializer to your Rails project (typically `config/initializers/devise.rb`):
```ruby
Devise.setup do |config|
  # ==> Configuration for :lockable
  # Defines which strategy will be used to lock an account.
  # :failed_attempts = Locks an account after a number of failed attempts to sign in.
  # :none            = No lock strategy. You should handle locking by yourself.
  config.lock_strategy = :failed_attempts

  # Defines which key will be used when locking and unlocking an account
  config.unlock_keys = [ :email ]

  # Defines which strategy will be used to unlock an account.
  # :email = Sends an unlock link to the user email
  # :time  = Re-enables login after a certain amount of time (see :unlock_in below)
  # :both  = Enables both strategies
  # :none  = No unlock strategy. You should handle unlocking by yourself.
  config.unlock_strategy = :both

  # Number of authentication tries before locking an account if lock_strategy
  # is failed attempts.
  config.maximum_attempts = 20

  # Time interval to unlock the account if :time is enabled as unlock_strategy.
  config.unlock_in = 1.hour

  # Warn on the last attempt before the account is locked.
  config.last_attempt_warning = true
end
```

* Then, create the migration as:

```ruby
rails g migration add_lockable_to_spree_auth
```

* Will generate db/migrate/YYYYMMDDxxx_add_lockable_to_spree_auth.rb. Add the following to it in order to do the migration.

```ruby
class AddLockableToSpreeAuth < ActiveRecord::Migration
  def change
    add_column :spree_users, :failed_attempts, :integer, default: 0, null: false # Only if lock strategy is :failed_attempts
    add_column :spree_users, :locked_at, :datetime

    # Add these only if unlock strategy is :email or :both
    add_column :spree_users, :unlock_token, :string
    add_index :spree_users, :unlock_token, unique: true
  end
end
```
### Sign out after password change

To disable signout after password change you must add this line to an initializer in your Rails project (typically `config/initializers/spree.rb`):

```ruby
Spree::Auth::Config[:signout_after_password_change] = false
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
<% if can? :show, SomeRailsObject %>

<% end %>
```

### Adding Permissions to Gems

This methodology can also be used by gems that extend spree and want/need to add permissions.

### Ruby 2.5 issues

If you encounter issues when using Ruby 2.5, please run:

```bash
bundle update devise
```

### Creating the default Admin user

If you didn't created the Admin user from the installer you can run this rake task:

```bash
bundle exec rake spree_auth:admin:create
```

## Testing

You need to do a quick one-time creation of a test application and then you can use it to run the tests.

    bundle exec rake test_app

Then run the rspec tests.

    bundle exec rspec

About Spark Solutions
----------------------
[![Spark Solutions](http://sparksolutions.co/wp-content/uploads/2015/01/logo-ss-tr-221x100.png)][spark]

Spree Auth Devise is maintained by [Spark Solutions Sp. z o.o.][spark].

We are passionate about open source software.
We are [available for hire][spark].

[spark]:http://sparksolutions.co?utm_source=github
