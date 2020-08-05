class Dispatch < ApplicationRecord

  belongs_to :user, optional: true

  validates :address, presence: true, length: { maximum: 100 }
  validates :passenger_id, presence: true, numericality: { only_integer: true }, allow_nil: false
  validates :driver_id, presence: true, numericality: { only_integer: true }, allow_nil: true
  validates :requested_at, presence: true
end
