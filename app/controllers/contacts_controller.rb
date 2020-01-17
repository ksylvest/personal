class ContactsController < ApplicationController
  # GET /contact/new
  def new
    @contact = Contact.new
  end

  # POST /contact
  def create
    @contact = Contact.new(attributes)

    if @contact.valid? && verified?
      Mailer.contact(@contact).deliver_now
      redirect_to root_path, notice: t('contact.notice')
    else
      flash.alert = t('contact.error')
      render :new
    end
  end

private

  def verified?
    Recaptcha.verified?(response: params.require(:recaptcha).fetch(:response), remoteip: request.ip)
  end

  def attributes
    params.require(:contact).permit(:name, :email, :subject, :message)
  end
end
