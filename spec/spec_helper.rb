require 'simplecov'
SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../dummy/config/environment', __FILE__)

require 'rspec/rails'
require 'shoulda-matchers'
require 'ffaker'
require 'pry'

require 'spree/testing_support/auth_helpers'
require 'spree/testing_support/checkout_helpers'

require 'spree/testing_support/authorization_helpers'
require 'spree/testing_support/capybara_ext'
require 'spree/testing_support/controller_requests'
require 'spree/testing_support/factories'
require 'spree/testing_support/url_helpers'

RSpec.configure do |config|
  config.filter_run focus: true
  config.infer_spec_type_from_file_location!
  config.raise_errors_for_deprecations!
  config.run_all_when_everything_filtered = true
  config.use_transactional_fixtures = false

  config.mock_with :rspec do |mock|
    mock.syntax = [:should, :expect]
  end

  config.order = :random
  Kernel.srand(config.seed)

  config.before(:each) do
    allow(RSpec::Rails::ViewRendering::EmptyTemplateHandler)
      .to receive(:call)
      .and_return(%("")) if Rails.gem_version >= Gem::Version.new('6.0.0.beta1')

    create(:store)
  end

  config.include Spree::TestingSupport::AuthHelpers, type: :feature
  config.include Spree::TestingSupport::CheckoutHelpers, type: :feature
  config.include Spree::TestingSupport::UrlHelpers
end

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }
