FactoryBot.define do
  factory :todo do
    address { Faker::Address.full_address }
    passenger_id { Faker::IDNumber.valid }
    driver_id nil
    requested_at { Faker::Date }
    accepted_id nil
  end
end