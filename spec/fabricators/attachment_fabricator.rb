Fabricator(:attachment) do
  name 'Attachment'
  file { File.open(Rails.root.join('spec', 'fixtures', 'attachment')) }
end
