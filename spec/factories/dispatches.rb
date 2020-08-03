FactoryBot.define do
  factory :dispatch do
    address { Faker::Address.full_address }
    passenger_id { Faker::Number.number }
    driver_id nil
    requested_at { Faker::Time.between(from: Time.now, to: 1.days.after)}
    accepted_at nil
  end
end
