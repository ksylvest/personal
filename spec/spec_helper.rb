require 'simplecov'
SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |file| require file }

ActiveRecord::Migration.maintain_test_schema!

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec.configure do |config|
  config.fixture_path = Rails.root.join('spec', 'fixtures')
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!

  config.include RSpec::Rails::RequestExampleGroup, type: :feature

  config.include ActionDispatch::TestProcess
end
