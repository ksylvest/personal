class Admin::UsersController < AdminController
  before_action :admin!

  # GET /admin/user/edit
  def edit
    @user = user
  end

  # PUT /admin/user
  def update
    @user = user

    if @user.update(attributes)
      redirect_to(restore(default: admin_path))
    else
      render :edit
    end
  end

private

  def attributes
    params.require(:user).permit(:name, :email, :password)
  end

end
