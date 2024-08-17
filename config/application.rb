require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Personal
  class Application < Rails::Application
    config.load_defaults 7.2

    config.middleware.use Rack::Deflater

    config.exceptions_app = routes

    config.generators do |g|
      g.helper false
      g.stylesheets false
      g.javascripts false
      g.test_framework :rspec, fixture: true, views: false
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
    end

    if ENV.include?('HOST')
      config.action_mailer.asset_host = ENV['HOST']
      config.action_controller.asset_host = ENV['HOST']
    end

    config.action_mailer.default_url_options ||= {}
    config.action_mailer.default_url_options[:host] = ENV.fetch('HOST', 'https://ksylvest.com')

    config.autoload_lib(ignore: %w[assets tasks])
  end
end
