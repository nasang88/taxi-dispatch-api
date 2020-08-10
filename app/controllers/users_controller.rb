class UsersController < ApplicationController

  skip_before_action :authorize

  #
  # POST /signup
  def create
    if User.exists?(email: user_params[:email])
      raise ExceptionHandler::ConflictData
    end

    user = User.create!(user_params)
    auth_user = Auth::AuthenticateService.new(user.email, user.password).call
    json_response(auth_user, :created)
  end

  private

  def user_params
    params.permit(
        :email,
        :password,
        :password_confirmation,
        :user_type
    )
end
end
