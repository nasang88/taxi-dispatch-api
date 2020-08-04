module ExceptionHandler
  extend ActiveSupport::Concern

  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end

  included do
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
    rescue_from ExceptionHandler::MissingToken, with: :unauthorized_request
    rescue_from ExceptionHandler::InvalidToken, with: :unauthorized_request

    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({}, :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      json_response({}, :bad_request)
    end
  end

  private

  def unauthorized_request(e)
    json_response({}, :unauthorized)
  end

end

