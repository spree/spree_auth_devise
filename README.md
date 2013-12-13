# Spree Auth (Devise)

[![Build Status](https://secure.travis-ci.org/spree/spree_auth_devise.png?branch=master)](https://travis-ci.org/spree/spree_auth_devise)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/spree/spree_auth_devise)

Provides authentication services for Spree, using the Devise gem.

## Installation

At one stage in the past, this used to be the auth component for Spree. If that's the feature that you're now finding lacking from Spree, that's easy fixed.

Just add this line to your Gemfile:

    gem "spree_auth_devise", :github => "spree/spree_auth_devise"

Please ensure you're using the correct branch of spree_auth_devise relative to
your version of Spree.

Spree 1.3.x or 1-3-stable:

    gem 'spree_auth_devise', :github => "spree/spree_auth_devise", :branch => "1-3-stable"

Spree 1.2.x or 1-2-stable:

    gem 'spree_auth_devise', :github => "spree/spree_auth_devise", :branch => "1-2-stable"

Then run `bundle install`. Authentication will then work exactly as it did in previous versions of Spree.

If you're installing this in a new Spree 1.2+ application, you'll need to install and run the migrations with

    bundle exec rake spree_auth:install:migrations
    bundle exec rake db:migrate
    bundle exec rails g spree:auth:install

and then, run this command in order to set up the admin user for the application.

    bundle exec rake spree_auth:admin:create

## Testing

You need to do a quick one-time creation of a test application and then you can use it to run the tests.

    bundle exec rake test_app

Then run the rspec tests.

    bundle exec rake spec

If everything doesn't pass on your machine (using Ruby (1.8.7 or 1.9.3) and (MySQL or PostgreSQL or SQLite3)) then we would consider that a bug. Please file a bug report on the issues page for this project with your test output
and we will investigate it.
