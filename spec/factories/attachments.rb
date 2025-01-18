FactoryBot.define do
  factory :attachment do
    name { "Attachment" }
    file { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures", fixture)) }

    transient do
      fixture { "attachment" }
    end

    trait :audio do
      fixture { "audio.wav" }
    end

    trait :image do
      fixture { "image.png" }
    end

    trait :video do
      fixture { "video.mov" }
    end

    trait :other do
      fixture { "other" }
    end
  end
end
