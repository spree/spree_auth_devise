RSpec.configure do |config|
  # allows to keep user const after reload
  config.around :each, :reload_user do |example|
    old_user = Spree::User

    example.run

    Spree.send(:remove_const, 'User')
    Spree.const_set('User', old_user)
  end
end
