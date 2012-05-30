# Spree Auth (Devise)

Provides authentication services for Spree, using the Devise gem.


## Installation

At one stage in the past, this used to be the auth component for Spree. If that's the feature that you're now finding lacking from Spree, that's easy fixed.

Just add this line to your Gemfile:

    gem "spree_auth_devise", :git => "git://github.com/spree/spree_auth_devise"

Then run `bundle install`. Authentication will then work exactly as it did in previous versions of Spree.


## Testing

You need to do a quick one-time creation of a test application and then you can use it to run the tests.

    bundle exec rake test_app

Then run the rspec tests

    bundle exec rake spec

If everything doesn't pass on your machine (using Ruby (1.8.7 or 1.9.3) and (MySQL or PostgreSQL or SQLite3)) then we would consider that a bug. Please file a bug report on the issues page for this project with your test output
and we will investigate it.
