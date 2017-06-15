module ConfigHelpers
  def with_config_option(key, value)
    option_was = Spree::Auth::Config[key]
    set_config_option(key, value)
    yield
    set_config_option(key, option_was)
  end

  def set_config_option(key, value)
    Spree::Auth::Config[key] = value
    Spree.send(:remove_const, 'User')
    load File.expand_path("../../../app/models/spree/user.rb", __FILE__)
  end
end

RSpec.configure do |c|
  c.include ConfigHelpers
end
