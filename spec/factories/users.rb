FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email 'taxi@remember.co.kr'
    password 'pw1234'
    type 'passenger'
  end
end