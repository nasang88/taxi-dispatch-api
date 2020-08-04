class User < ApplicationRecord
  has_secure_password

  enum user_type: { passenger: "passenger", driver: "driver" }

  validates_presence_of :email, :password_digest, :user_type
end