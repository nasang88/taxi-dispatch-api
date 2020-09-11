module ExceptionHandler
  extend ActiveSupport::Concern

  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end
  class ConflictData < StandardError; end
  class InvalidUser < StandardError; end

  included do
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
    rescue_from ExceptionHandler::MissingToken, with: :unauthorized_request
    rescue_from ExceptionHandler::InvalidToken, with: :unauthorized_request
    rescue_from ExceptionHandler::ConflictData, with: :conflict_request
    rescue_from ExceptionHandler::InvalidUser, with: :bad_requset

    rescue_from ActionController::ParameterMissing, with: :bad_requset
    rescue_from ActiveRecord::RecordInvalid, with: :bad_requset

    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({}, :not_found)
    end
  end

  private

  def unauthorized_request(e)
    json_response({}, :unauthorized)
  end

  def conflict_request(e)
    json_response({}, :conflict)
  end

  def bad_requset(e)
    json_response({}, :bad_request)
  end

end

