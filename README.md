# Spree Auth (Devise)

<<<<<<< HEAD
[![Build Status](https://secure.travis-ci.org/spree/spree_auth_devise.png?branch=1-2-stable)](https://travis-ci.org/spree/spree_auth_devise)
=======
[![Build Status](https://secure.travis-ci.org/spree/spree_auth_devise.png?branch=master)](https://travis-ci.org/spree/spree_auth_devise)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/spree/spree_auth_devise)
>>>>>>> f05a575d0f28924f1eb41dd2e43165eb34a30493

Provides authentication services for Spree, using the Devise gem.

## Installation

At one stage in the past, this used to be the auth component for Spree. If that's the feature that you're now finding lacking from Spree, that's easy fixed.

Just add this line to your Gemfile:

    gem 'spree_auth_devise', :git => 'git://github.com/spree/spree_auth_devise', :branch => '1-2-stable'

Then run `bundle install`. Authentication will then work exactly as it did in previous versions of Spree.

If you're installing this in a new Spree 1.2+ application, you'll need to install and run the migrations with

    bundle exec rake spree_auth:install:migrations
    bundle exec rake db:migrate

and then, run `bundle exec rake spree_auth:admin:create` in order to set up the admin user for the application.

If you're updating a Spree 1.1 application, run these to migrate the database:

    rake railties:install:migrations
    rake db:migrate


## Testing

You need to do a quick one-time creation of a test application and then you can use it to run the tests.

    bundle exec rake test_app

Then run the rspec tests

    bundle exec rake spec

If everything doesn't pass on your machine (using Ruby (1.8.7 or 1.9.3) and (MySQL or PostgreSQL or SQLite3)) then we would consider that a bug. Please file a bug report on the issues page for this project with your test output
and we will investigate it.
