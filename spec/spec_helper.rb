require "simplecov"
SimpleCov.start "rails"

ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../../config/environment", __FILE__)
require "rspec/rails"

Rails.root.glob("spec/support/**/*.rb").each { |file| require file }

ActiveJob::Base.queue_adapter = :test

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  config.include RSpec::Rails::RequestExampleGroup, type: :feature
end
