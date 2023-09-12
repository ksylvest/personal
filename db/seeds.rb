user = User.find_or_initialize_by(email: 'kevin@ksylvest.com')
user.name = 'Kevin Sylvestre'
user.password = 'secret'
user.role = 'admin'
user.save!
