class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler

  before_action :authorize
  attr_reader :current_user

  private

  def authorize
    @current_user = Auth::AuthorizeService.new(request.headers).call
  end

end
