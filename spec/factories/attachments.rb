FactoryBot.define do
  factory :attachment do
    name { 'Attachment' }
    file { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', fixture)) }

    transient do
      fixture { 'attachment' }
    end

    trait :image do
      fixture { 'image.png' }
    end
  end
end
