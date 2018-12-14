namespace :db do
  namespace :populate do
    desc 'Populate the DB with posts'
    task posts: :environment do
      32.times_with_progress 'Posts' do
        Fabricate(:post)
      end
    end
  end
end
