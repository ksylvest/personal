FactoryBot.define do
  factory :post do
    user
    status { Approvable::Status::ACTIVE }
    title { "Rails" }
    summary { "An overview of rails." }
    body { "Rails is a web application framework." }
  end
end
