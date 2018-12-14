class ApplicationController < ActionController::Base
  etag { user&.id }

  protect_from_forgery with: :exception

  helper_method :user
  helper_method :authenticated?

protected

  def user
    return @_user if @_user

    cookie = cookies.signed[:user]
    @_user = User.find(cookie) if cookie
  end

  def authenticate(user)
    cookies.permanent.signed[:user] = user.id
  end

  def deauthenticate
    cookies.delete :user
  end

  def authenticated?
    user.present?
  end

  def admin!
    return if authenticated? && user.admin?

    store
    redirect_to new_admin_session_path, alert: 'You must be an admin.'
  end

  def authenticate!
    return if authenticated?

    store
    redirect_to root_path, alert: 'You must be logged in.'
  end

  def deauthenticate!
    return unless authenticated?

    store
    redirect_to root_path, alert: 'You must be logged out.'
  end

  def store
    session[:location] = request.fullpath
  end

  def restore(default:)
    session.delete(:location) || default
  end

end
