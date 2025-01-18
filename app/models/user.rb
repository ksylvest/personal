class User < ApplicationRecord
  module Role
    ADMIN = "admin".freeze
    GUEST = "guest".freeze
  end

  ROLES = [
    Role::ADMIN,
    Role::GUEST,
  ].freeze

  has_secure_password validations: false

  has_many :posts, dependent: :nullify
  has_many :pages, dependent: :nullify

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: Validation::EMAIL, message: "should be an email" }
  validates :password, length: { in: 4..64 }, presence: true, unless: ->(user) { user.password_digest.present? }
  validates :role, inclusion: { in: ROLES }

  after_initialize { self.role ||= Role::GUEST }

  has_one_attached :avatar
end
