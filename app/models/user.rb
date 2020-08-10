class User < ApplicationRecord

  has_many :dispatch

  enum user_type: { passenger: "passenger", driver: "driver" }

  validates_uniqueness_of :email
  validates_presence_of :email, :password_digest, :user_type

  has_secure_password
end
