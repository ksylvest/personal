Raven.configure do |config|
  config.dsn = Rails.application.credentials.sentry_dsn unless Rails.env.test? || Rails.env.development?
end
