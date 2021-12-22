class Admin::SessionsController < AdminController
  # GET /session/new
  def new
    @session = Session.new
  end

  # POST /session
  def create
    @session = Session.new(attributes)

    if @session.valid?
      authenticate(@session.user)
      redirect_to restore(default: admin_path)
    else
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /session
  def destroy
    deauthenticate

    redirect_to(new_admin_session_path)
  end

private

  def attributes
    params.require(:session).permit(:email, :password)
  end
end
