Fabricator(:page) do
  status { Approvable::Status::ACTIVE }
  user { Fabricate(:user) }
  title { Faker::Name.name }
  summary { Faker::Lorem.paragraph }
  body { Faker::Lorem.paragraph }
  tags { Faker::Lorem.words }
end
