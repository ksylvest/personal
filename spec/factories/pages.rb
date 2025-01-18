FactoryBot.define do
  factory :page do
    user
    status { Approvable::Status::ACTIVE }
    title { "Ruby" }
    summary { "An overview of ruby." }
    body { "Ruby is an interpreted programming language." }
  end
end
