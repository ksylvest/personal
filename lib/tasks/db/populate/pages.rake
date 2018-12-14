namespace :db do
  namespace :populate do
    desc 'Populate the DB with pages'
    task pages: :environment do
      4.times_with_progress 'Pages' do
        Fabricate(:page)
      end
    end
  end
end
