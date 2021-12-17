require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Personal
  class Application < Rails::Application
    config.load_defaults 7.0

    config.middleware.use Rack::Deflater

    config.exceptions_app = routes

    config.generators do |g|
      g.helper false
      g.stylesheets false
      g.javascripts false
      g.template_engine :slim
      g.test_framework :rspec, fixture: true, views: false
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
    end

    if Rails.application.credentials.mailgun.present?
      config.action_mailer.smtp_settings = {
        address: 'smtp.mailgun.org',
        port: 587,
        authentication: :plain,
        user_name: Rails.application.credentials.mailgun[:username],
        password: Rails.application.credentials.mailgun[:password],
        domain: Rails.application.credentials.mailgun[:domain],
      }
    end

    if ENV.include?('HOST')
      config.action_mailer.asset_host = ENV['HOST']
      config.action_controller.asset_host = ENV['HOST']
    end

    if ENV.include?('REDIS_CACHE_URL')
      config.cache_store = :redis_cache_store, {
        url: ENV['REDIS_CACHE_URL'],
      }
    end

    config.action_mailer.default_url_options ||= {}
    config.action_mailer.default_url_options[:host] = ENV.fetch('HOST') { 'https://ksylvest.com' }
  end
end
