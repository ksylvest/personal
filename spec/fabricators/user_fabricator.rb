Fabricator(:user) do
  name { Faker::Name.name }
  email { "#{Fabricate.sequence}@test.host" }
  password { 'secret' }
end
