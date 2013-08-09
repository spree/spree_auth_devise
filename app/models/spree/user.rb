module Spree
  class User < ActiveRecord::Base
    include Core::UserBanners

    devise :database_authenticatable, :token_authenticatable, :registerable, :recoverable,
           :rememberable, :trackable, :validatable, :encryptable, :encryptor => 'authlogic_sha512'

    has_many :orders
    belongs_to :ship_address, :foreign_key => 'ship_address_id', :class_name => 'Spree::Address'
    belongs_to :bill_address, :foreign_key => 'bill_address_id', :class_name => 'Spree::Address'

    before_validation :set_login
    before_destroy :check_completed_orders

    # Setup accessible (or protected) attributes for your model
    # attr_accessible :email, :password, :password_confirmation, :remember_me, :persistence_token, :login

    users_table_name = User.table_name
    roles_table_name = Role.table_name

    scope :admin, lambda { includes(:spree_roles).where("#{roles_table_name}.name" => "admin") }
    scope :registered, -> { where("#{users_table_name}.email NOT LIKE ?", "%@example.net") }

    class DestroyWithOrdersError < StandardError; end

    # Creates an anonymous user.  An anonymous user is basically an auto-generated +User+ account that is created for the customer
    # behind the scenes and its completely transparently to the customer.  All +Orders+ must have a +User+ so this is necessary
    # when adding to the "cart" (which is really an order) and before the customer has a chance to provide an email or to register.
    def self.anonymous!
      token = User.generate_token(:persistence_token)
      User.create(:email => "#{token}@example.net", :password => token, :password_confirmation => token, :persistence_token => token)
    end

    def self.admin_created?
      User.admin.count > 0
    end

    def admin?
      has_spree_role?('admin')
    end

    def anonymous?
      email =~ /@example.net$/ ? true : false
    end

    def send_reset_password_instructions
      generate_reset_password_token!
      UserMailer.reset_password_instructions(self).deliver
    end

    protected
      def password_required?
        !persisted? || password.present? || password_confirmation.present?
      end

    private

      def check_completed_orders
        raise DestroyWithOrdersError if orders.complete.present?
      end

      def set_login
        # for now force login to be same as email, eventually we will make this configurable, etc.
        self.login ||= self.email if self.email
      end

      # Generate a friendly string randomically to be used as token.
      def self.friendly_token
        SecureRandom.base64(15).tr('+/=', '-_ ').strip.delete("\n")
      end

      # Generate a token by looping and ensuring does not already exist.
      def self.generate_token(column)
        loop do
          token = friendly_token
          break token unless where(column => token).first
        end
      end
  end
end
