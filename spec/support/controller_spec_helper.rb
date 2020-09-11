module ControllerSpecHelper
  def token_generator(user_id)
    JsonWebToken.encode(user_id: user_id)
  end

  def expired_token_generator(user_id)
    JsonWebToken.encode({ user_id: user_id }, (Time.now.to_i - 10))
  end

  def valid_headers(user_id:)
    {
        "Authorization" => token_generator(user_id || user.id),
        "Content-Type" => "application/json"
    }
  end

  def raw_valid_headers(user_id:)
    {
        "Authorization" => token_generator(user_id)
    }
  end

  def invalid_headers
    {
        "Authorization" => nil,
        "Content-Type" => "application/json"
    }
  end
end
