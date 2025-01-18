FactoryBot.define do
  factory :session do
    sequence(:email) { |index| "#{index}@test.host" }
    password { "secret" }
  end
end
