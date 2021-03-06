FactoryGirl.define do
  factory :private_todo do
    title { Faker::Lorem.word }
    user_id { Faker::Number.number(10) }
    type { 'PrivateTodo' }
  end
end
