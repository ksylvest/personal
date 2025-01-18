namespace :favicon do
  desc "generate a favicon"
  task generate: :environment do
    `sketchtool export artboards #{Rails.root.join("doc/favicon.sketch")} --output=#{Rails.root.join("tmp")}`
    `convert #{Rails.root.join("tmp/favicon-*.png")} #{Rails.root.join("app/assets/images?favicon.ico")}`
    `rm #{Rails.root.join("tmp/favicon-*")}`
  end
end
