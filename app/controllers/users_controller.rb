class UsersController < ApplicationController
  def create
    user = User.create!(user_params)
    auth_user = AuthenticateUser.new(user.email, user.password).call
    json_response(auth_user)
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
