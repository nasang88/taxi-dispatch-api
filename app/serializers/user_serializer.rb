class UserSerializer < BaseSerializer
  def serialized_hash
    return unless m
    {
        id: m.id,
        email: m.email,
        user_type: m.user_type,
        auth_token: JsonWebToken.encode(user_id: m.id)
    }
  end
end
