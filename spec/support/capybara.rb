RSpec.configure do |config|
  config.before(type: :system) do
    driven_by :selenium, using: :headless_chrome, screen_size: [1280, 800]
  end
end
