require 'rails_helper'

RSpec.describe Dispatch, type: :model do
  it { should validate_presence_of(:address) }
  it { should validate_length_of(:address).is_at_most(100) }
  it { should validate_presence_of(:passenger_id) }
  it { should validate_numericality_of(:passenger_id).only_integer.is_less_than_or_equal_to(99999999999) }
  it { should validate_numericality_of(:driver_id).only_integer.is_less_than_or_equal_to(99999999999).allow_nil }
  it { should validate_presence_of(:requested_at) }
end
