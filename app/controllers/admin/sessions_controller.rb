class Admin::SessionsController < AdminController
  before_action :admin!, only: %i[destroy]
  before_action :deauthenticate!, only: %i[new create]

  # GET /admin/session/new
  def new
    @session = Session.new
  end

  # POST /admin/session
  def create
    @session = Session.new(attributes)

    if @session.valid?
      authenticate(@session.user)
      redirect_to restore(default: admin_path)
    else
      render :new
    end
  end

  # DELETE /admin/session
  def destroy
    deauthenticate

    redirect_to(root_path)
  end

private

  def attributes
    params.require(:session).permit(:email, :password)
  end

end
