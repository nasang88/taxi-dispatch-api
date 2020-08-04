FactoryBot.define do
  factory :user do
    email 'taxi@remember.co.kr'
    password 'pw1234'
    user_type 'passenger'
  end
end