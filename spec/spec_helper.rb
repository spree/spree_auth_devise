# frozen_string_literal: true

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require File.expand_path('dummy/config/environment.rb', __dir__)

require 'spree_dev_tools/rspec/spec_helper'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its sub-directories.
Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].sort.each { |f| require f }

require 'spree/testing_support/locale_helpers' if Spree.version.to_f >= 4.2

RSpec.configure do |config|
  config.before(:each) do
    if Rails.gem_version >= Gem::Version.new('6.0.0.beta1')
      allow(RSpec::Rails::ViewRendering::EmptyTemplateHandler)
        .to receive(:call)
        .and_return(%(""))
    end
  end

  config.include Spree::TestingSupport::LocaleHelpers if defined?(Spree::TestingSupport::LocaleHelpers)
end
