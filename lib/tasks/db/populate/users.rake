namespace :db do
  namespace :populate do
    desc 'Populate the DB with users'
    task users: :environment do
      2.times_with_progress 'Users' do
        Fabricate(:user)
      end
    end
  end
end
