module RegisterHelpers
  def set_registerable_option(value)
    Spree::Auth::Config[:registerable] = value
    Spree.send(:remove_const, 'User')
    load File.expand_path('../../../app/models/spree/user.rb', __FILE__)
  end
end

RSpec.configure do |c|
  c.include RegisterHelpers
end
