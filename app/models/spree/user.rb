module Spree
  class User < ActiveRecord::Base
    include UserAddress
    include UserPaymentSource

    devise :database_authenticatable, :registerable, :recoverable,
           :rememberable, :trackable, :encryptable, :encryptor => 'authlogic_sha512'
    devise :confirmable if Spree::Auth::Config[:confirmable]

    validates_presence_of   :email, if: :email_required?
    validates_uniqueness_of :email, allow_blank: true, scope: :store_group, if: :email_changed?
    validates_format_of     :email, with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, allow_blank: true, if: :email_changed?

    validates_presence_of     :password, if: :password_required?
    validates_confirmation_of :password, if: :password_required?
    validates_length_of       :password, within: 1..128, allow_blank: true

    acts_as_paranoid
    after_destroy :scramble_email_and_password

    has_many :orders

    before_validation :set_login

    users_table_name = User.table_name
    roles_table_name = Role.table_name

    scope :admin, -> { includes(:spree_roles).where("#{roles_table_name}.name" => "admin") }
    scope :with_role, -> (role_name) { includes(:spree_roles).where("#{roles_table_name}.name" => role_name) if role_name.present? }

    def self.admin_created?
      User.admin.count > 0
    end

    def admin?
      has_spree_role?('admin')
    end

    protected
      def password_required?
        !persisted? || password.present? || password_confirmation.present?
      end

    private

      def self.ransackable_scopes(_auth_object)
        %i(with_role)
      end

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

      def email_required?
        true
      end
  end
end
