class User < ApplicationRecord
  has_secure_password

  has_one :passenger_user, class_name: "User", foreign_key: "passenger_id"
  has_one :driver_user, class_name: "User", foreign_key: "driver_id"

  validates_presence_of :email, :password_digest, :user_type
end