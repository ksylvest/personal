Fabricator(:post) do
  status { Approvable::Status::ACTIVE }
  user { Fabricate(:user) }
  title { Faker::Name.name }
  body { Faker::Lorem.paragraph }
  summary { Faker::Lorem.paragraph }
  tags { Faker::Lorem.words }
end
