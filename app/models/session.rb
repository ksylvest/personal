class Session
  include ActiveModel::Model

  attr_accessor :email
  attr_accessor :password

  validates :email, presence: true, format: { with: Validation::EMAIL, message: 'should be an email' }
  validates :password, presence: true

  validate do
    if errors.blank?
      errors[:email]    << 'is invalid' unless user
      errors[:password] << 'is incorrect' unless user&.authenticate(password)
    end
  end

  def initialize(attributes = {})
    self.email    = attributes[:email]
    self.password = attributes[:password]
  end

  def user
    @user ||= User.find_by(email: email)
  end

  def persisted?
    user&.authenticate(password)
  end
end
