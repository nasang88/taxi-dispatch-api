FactoryBot.define do
  factory :user, class: User do
    email 'default@remember.co.kr'
    password 'pw1234'
    user_type 'passenger'
  end

  factory :passenger_user, class: User do
    email 'passenger@remember.co.kr'
    password 'pw1234'
    user_type 'passenger'
  end

  factory :driver_user, class: User  do
    email 'driver@remember.co.kr'
    password 'pw1234'
    user_type 'driver'
  end

  factory :another_passenger_user, class: User do
    email 'passenger_another@remember.co.kr'
    password 'pw1234'
    user_type 'passenger'
  end

  factory :another_driver_user, class: User  do
    email 'driver_another@remember.co.kr'
    password 'pw1234'
    user_type 'driver'
  end
end