module Spree
  module Auth
    VERSION = '4.3.3'.freeze

    def gem_version
      Gem::Version.new(VERSION)
    end
  end
end
