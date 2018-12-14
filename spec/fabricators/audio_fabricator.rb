Fabricator(:audio) do
  name 'Audio'
  file { File.open(Rails.root.join('spec', 'fixtures', 'audio.wav')) }
end
