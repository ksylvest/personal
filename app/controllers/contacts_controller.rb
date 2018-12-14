class ContactsController < ApplicationController

  # GET /contact/new
  def new
    @contact = Contact.new
  end

  # POST /contact
  def create
    @contact = Contact.new(attributes)

    if @contact.valid?
      Mailer.contact(@contact).deliver_now
      redirect_to root_path
    else
      render :new
    end
  end

private

  def attributes
    params.require(:contact).permit(:name, :email, :subject, :message)
  end

end
