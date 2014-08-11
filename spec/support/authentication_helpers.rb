module AuthenticationHelpers
  def sign_in_as!(user)
    visit '/login'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'secret'
    click_button 'Login'
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelpers, type: :feature
  config.include Devise::TestHelpers,   type: :controller
  config.include Rack::Test::Methods,   type: :feature
end
