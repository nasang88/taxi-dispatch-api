module Auth
  class AuthenticateService
    def initialize(email, password)
      @email = email
      @password = password
    end

    def call
      AuthTokenSerializer.new(user).serialized_hash if user
    end

    private

    attr_reader :email, :password

    def user
      user = User.find_by(email: email)
      return user if user && user.authenticate(password)
      raise(ExceptionHandler::AuthenticationError)
    end
  end
end
