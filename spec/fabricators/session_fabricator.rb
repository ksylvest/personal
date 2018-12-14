Fabricator(:session) do
  email { "#{Fabricate.sequence}@test.host" }
  password { 'secret' }
end
