RSpec.configure do |config|
  config.after do
    Spree::Ability.abilities.delete(AbilityDecorator) if Spree::Ability.abilities.include?(AbilityDecorator)
  end
end

if defined? CanCan::Ability
  class AbilityDecorator
    include CanCan::Ability

    def initialize(_user)
      cannot :manage, Spree::Order
    end
  end
end
