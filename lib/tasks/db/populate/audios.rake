namespace :db do
  namespace :populate do
    desc 'Populate the DB with audios'
    task audios: :environment do
      2.times_with_progress 'Audios' do
        Fabricate(:audio)
      end
    end
  end
end
