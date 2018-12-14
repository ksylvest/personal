namespace :db do
  namespace :populate do
    desc 'Populate the DB with images'
    task images: :environment do
      2.times_with_progress 'Images' do
        Fabricate(:image)
      end
    end
  end
end
