module Spree
  module Auth
    VERSION = '4.3.4'.freeze

    def gem_version
      Gem::Version.new(VERSION)
    end
  end
end
