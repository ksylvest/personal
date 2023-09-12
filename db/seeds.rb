User.find_or_create_by!(email: 'kevin@ksylvest.com') do |user|
  user.name = 'Kevin Sylvestre'
  user.password = 'secret'
  user.role = 'admin'
end

YAML.load_file(Rails.root.join('db/seeds/portfolio.yml')).each do |attributes|
  Portfolio.find_or_create_by!(name: attributes['name']) do |portfolio|
    portfolio.summary = attributes['summary']
    attributes['images'].each do |filename|
      file = Rails.root.join("doc/portfolio/#{attributes['slug']}/#{filename}").open
      portfolio.images.attach(io: file, filename: filename)
    end
  end
end
