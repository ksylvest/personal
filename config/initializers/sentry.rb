SENTRY_TRACES_SAMPLE_RATE = Float(ENV.fetch('SENTRY_TRACES_SAMPLE_RATE', 1.0))

Sentry.init do |config|
  config.dsn = Rails.application.credentials.sentry_dsn unless Rails.env.test? || Rails.env.development?
  config.traces_sample_rate = SENTRY_TRACES_SAMPLE_RATE
end
