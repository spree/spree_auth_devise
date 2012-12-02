require 'spree/core'
require 'devise'
# require 'devise-encryptable'
require 'cancan'

module Spree
  module Auth
    def self.config(&block)
      yield(Spree::Auth::Config)
    end
  end
end

require 'spree/auth/engine'
