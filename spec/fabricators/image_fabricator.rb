Fabricator(:image) do
  name 'Image'
  file { File.open(Rails.root.join('spec', 'fixtures', 'image.png')) }
end
