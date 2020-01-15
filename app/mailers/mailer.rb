class Mailer < ApplicationMailer
  def contact(contact)
    @name = contact.name
    @email = contact.email

    mail reply_to: "#{@name} <#{@email}>", subject: contact.subject, body: contact.message
  end
end
