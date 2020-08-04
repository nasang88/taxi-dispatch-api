class AuthenticationController < ApplicationController
  def authenticate
    auth_user = Auth::AuthenticateService.new(auth_params[:email], auth_params[:password]).call
    json_response(auth_user)
  end

  private

  def auth_params
    params.permit(:email, :password)
  end
end
