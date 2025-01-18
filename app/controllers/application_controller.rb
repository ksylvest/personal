class ApplicationController < ActionController::Base
  etag { user&.id }

  protect_from_forgery with: :exception

  helper_method :user
  helper_method :authenticated?

protected

  def user
    @user ||= begin
      user_id = cookies.encrypted[:user_id]
      User.find(user_id) if user_id
    end
  end

  def authenticate(user)
    @user = user
    cookies.encrypted[:user_id] = user.id
  end

  def deauthenticate
    @user = nil
    cookies.delete :user
  end

  def authenticated?
    user.present?
  end

  def admin!
    authenticate!(role: User::Role::ADMIN)
  end

  def authenticate!(role:)
    return if authenticated? && user.role.eql?(role)

    store
    redirect_to new_admin_session_path, alert: "You must be authenticated."
  end

  def store
    session[:location] = request.fullpath
  end

  def restore(default:)
    session.delete(:location) || default
  end
end
