require 'spree/core'
require 'devise'
require 'devise-encryptable'
require 'cancan'

Devise.secret_key = SecureRandom.hex(50)

module Spree
  module Auth
    mattr_accessor :default_secret_key

    def self.config(&block)
      yield(Spree::Auth::Config)
    end
  end
end

Spree::Auth.default_secret_key = Devise.secret_key

require 'spree/auth/engine'
