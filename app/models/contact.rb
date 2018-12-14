class Contact
  include ActiveModel::Model

  attr_accessor :name
  attr_accessor :email
  attr_accessor :subject
  attr_accessor :message

  validates :name, presence: true
  validates :email, presence: true, format: { with: Validation::EMAIL, message: 'should be an email' }
  validates :subject, presence: true
  validates :message, presence: true

  def initialize(attributes = {})
    @name    = attributes[:name]
    @email   = attributes[:email]
    @subject = attributes[:subject]
    @message = attributes[:message]
  end

end
