Fabricator(:attachment) do
  name 'Attachment'
  file { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'attachment')) }
end
