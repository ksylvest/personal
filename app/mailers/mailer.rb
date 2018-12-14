class Mailer < ApplicationMailer

  def contact(contact)
    @name = contact.name
    @email = contact.email

    mail from: "#{@name} <#{@email}>", subject: contact.subject, body: contact.message
  end

end
