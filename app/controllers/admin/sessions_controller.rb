class Admin::SessionsController < AdminController
  # GET /session/new
  def new
    @session = Session.new
  end

  # POST /session
  def create
    @session = Session.new(attributes)
    user = @session.authenticate

    if user
      authenticate(user)
      redirect_to restore(default: admin_path)
    else
      render :new, status: :unprocessable_content
    end
  end

  # DELETE /session
  def destroy
    deauthenticate

    redirect_to(new_admin_session_path)
  end

private

  def attributes
    params.expect(session: %i[email password])
  end
end
