FactoryBot.define do
  factory :user do
    name { "Kevin Sylvestre" }
    sequence(:email) { |index| "#{index}@test.host" }
    password { "secret" }
  end
end
