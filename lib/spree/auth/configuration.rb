module Spree
  module Auth
    class Configuration
      attr_accessor :registration_step,
                    :signout_after_password_change,
                    :confirmable,
                    :database_authenticatable,
                    :recoverable,
                    :registerable,
                    :validatable

      def initialize
        self.registration_step = true
        self.signout_after_password_change = true
        self.confirmable = false
        self.database_authenticatable = true
        self.recoverable = true
        self.registerable = true
        self.validatable = true
      end

      def configure
        yield(self) if block_given?
      end

      def get(preference)
        send(preference)
      end

      alias [] get

      def set(preference, value)
        send("#{preference}=", value)
      end

      alias []= set
    end
  end
end
