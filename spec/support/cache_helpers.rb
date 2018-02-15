RSpec.configure do |config|
  config.before do
    Rails.cache.clear
  end
end
