class Session
  include ActiveModel::Model

  INVALID_EMAIL_OR_PASSWORD_MESSAGE = 'the email and password entered did not match our records'.freeze
  private_constant :INVALID_EMAIL_OR_PASSWORD_MESSAGE

  attr_accessor :email
  attr_accessor :password

  validates :email, presence: true
  validates :email, format: { with: Validation::EMAIL, message: 'must be an email' }, if: -> { email.present? }
  validates :password, presence: true

  validate do
    errors.add(:base, :invalid, message: INVALID_EMAIL_OR_PASSWORD_MESSAGE) if errors.blank? && !user
  end

  def authenticate
    user if valid?
  end

private

  def user
    return @user if defined?(@user)

    @user = User.authenticate_by(email:, password:)
  end

end
