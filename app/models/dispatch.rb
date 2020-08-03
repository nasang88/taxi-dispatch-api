class Dispatch < ApplicationRecord

  validates :address, presence: true, length: { maximum: 100 }
  validates :passenger_id, presence: true, numericality: { only_integer: true, less_than_or_equal_to: 99999999999 }, allow_nil: false
  validates :driver_id, presence: true, numericality: { only_integer: true, less_than_or_equal_to: 99999999999 }, allow_nil: true
  validates :requested_at, presence: true
end
