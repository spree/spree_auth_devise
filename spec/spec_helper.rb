# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require File.expand_path('../dummy/config/environment.rb', __FILE__)

require 'spree_dev_tools/rspec/spec_helper'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].sort.each { |f| require f }

RSpec.configure do |config|
  config.before(:each) do
    allow(RSpec::Rails::ViewRendering::EmptyTemplateHandler)
      .to receive(:call)
      .and_return(%("")) if Rails.gem_version >= Gem::Version.new('6.0.0.beta1')
  end
end
