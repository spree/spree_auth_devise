module Spree
  class User < Spree::Base
    include UserAddress
    include UserMethods
    include UserPaymentSource

    devise :database_authenticatable, :registerable, :recoverable,
           :rememberable, :trackable, :validatable
    devise :confirmable if Spree::Auth::Config[:confirmable]

    # Devise's default encryptor is bcrypt and does not require the encryptable
    # module to be loaded.
    if Spree::Auth::Config[:encryptor] != 'bcrypt'
      devise :encryptable, :encryptor => Spree::Auth::Config[:encryptor]
    end

    acts_as_paranoid
    after_destroy :scramble_email_and_password

    before_validation :set_login

    users_table_name = User.table_name
    roles_table_name = Role.table_name

    scope :admin, -> { includes(:spree_roles).where("#{roles_table_name}.name" => "admin") }

    def self.admin_created?
      User.admin.exists?
    end

    def admin?
      has_spree_role?('admin')
    end

    protected
      def password_required?
        !persisted? || password.present? || password_confirmation.present?
      end

    private

      def set_login
        # for now force login to be same as email, eventually we will make this configurable, etc.
        self.login ||= self.email if self.email
      end

      def scramble_email_and_password
        self.email = SecureRandom.uuid + "@example.net"
        self.login = self.email
        self.password = SecureRandom.hex(8)
        self.password_confirmation = self.password
        self.save
      end
  end
end
