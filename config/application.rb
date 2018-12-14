require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Personal
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Initialize rack deflater for gzip.
    config.middleware.use Rack::Deflater

    # Customize the application to use internal routing for all exceptions.
    config.exceptions_app = routes

    # Override the default generators.
    config.generators do |g|
      g.helper false
      g.stylesheets false
      g.javascripts false
      g.template_engine :slim
      g.test_framework :rspec, fixture: true, views: false
      g.fixture_replacement :fabrication
    end

    # Configure email sending through SendGrid if credentials are supplied.
    if ENV.include?('SENDGRID_USERNAME') && ENV.include?('SENDGRID_PASSWORD')
      config.action_mailer.smtp_settings = {
        address: 'smtp.sendgrid.net',
        port: 587,
        user_name: ENV['SENDGRID_USERNAME'],
        password: ENV['SENDGRID_PASSWORD'],
        authentication: :plain,
        domain: 'ksylvest.com',
      }
    end

    # Configure assets hosts if the settings are supplied.
    if ENV.include?('HOST')
      config.action_mailer.asset_host = ENV['HOST']
      config.action_controller.asset_host = ENV['HOST']
    end

    # Configure the default cache store to be a good one.
    if ENV.include?('REDIS_CACHE_URL')
      config.cache_store = :redis_cache_store, {
        url: ENV['REDIS_CACHE_URL'],
      }
    end

    # Configure a default host.
    config.action_mailer.default_url_options ||= {}
    config.action_mailer.default_url_options[:host] = ENV.fetch('HOST') { 'https://ksylvest.com' }

  end
end
