RSpec.configure do |config|
  config.around do |example|
    if example.metadata.key?(:confirmable)
      old_user = Spree::User

      begin
        example.run
      ensure
        Spree.const_set('User', old_user)
      end
    else
      example.run
    end
  end

  config.before do |example|
    if example.metadata.key?(:confirmable)
      Spree::Auth::Config[:confirmable] = example.metadata[:confirmable]

      Spree.send(:remove_const, :User)
      load File.expand_path('../../../app/models/spree/user.rb', __FILE__)
    end
  end
end
