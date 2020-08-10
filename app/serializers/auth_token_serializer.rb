class AuthTokenSerializer < BaseSerializer
  def serialized_hash
    return unless m
    {
        auth_token: JsonWebToken.encode(user_id: m.id)
    }
  end
end
