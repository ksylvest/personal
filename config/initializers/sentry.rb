Sentry.init do |config|
  if Rails.env.production?
    config.dsn = Rails.application.credentials.sentry_dsn
    config.traces_sample_rate = Float(ENV["SENTRY_TRACE_SAMPLE_RATE"]) if ENV["SENTRY_TRACE_SAMPLE_RATE"]
  end
end
