class AuthsController < ApplicationController
  # POST /auth
  def create
    user = GlobalID::Locator.locate_signed(params[:token], for: "auth")
    authenticate(user)
    head :ok
  end

  # DELETE /auth
  def destroy
    deauthenticate
    head :ok
  end
end
