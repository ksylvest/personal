Analytic.configure do |config|
  config.timezone = Time.find_zone('Canada/Pacific')

  config.use Rack::Auth::Basic { |email, password| User.authenticate_by(email:, password:) }
end
