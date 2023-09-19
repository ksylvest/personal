RSpec.configure do |config|
  config.before(type: :system) do
    driven_by :selenium, using: :headless_chrome do |options|
      options.add_argument('--disable-dev-shm-usage')
    end
  end
end
