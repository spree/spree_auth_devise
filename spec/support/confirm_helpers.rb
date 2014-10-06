module ConfirmHelpers
  def set_confirmable_option(value)
    Spree::Auth::Config[:confirmable] = value
    Spree.send(:remove_const, 'User')
    load File.expand_path("../../../app/models/spree/user.rb", __FILE__)
  end
end

RSpec.configure do |c|
  c.include ConfirmHelpers
end