namespace :db do
  desc 'Populate the DB with data'
  task populate: %w[populate:users populate:pages populate:posts]
end
