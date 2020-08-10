module Auth
  class AuthorizeService
    def initialize(headers = {})
      @headers = headers
    end

    def call
      UserSerializer.new(user).serialized_hash
    end

    private

    attr_reader :headers

    def user
      return user ||= User.find(decoded_auth_token[:user_id]) if decoded_auth_token

    rescue ActiveRecord::RecordNotFound => e
      raise(
          ExceptionHandler::InvalidToken
      )
    end

    def decoded_auth_token
      @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
    end

    def http_auth_header
      if headers['Authorization'].present?
        return headers['Authorization'].split(' ').last
      end
      raise(ExceptionHandler::MissingToken)
    end
  end
end
