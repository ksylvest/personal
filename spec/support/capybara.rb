RSpec.configure do |config|
  config.before(type: :system) do
    driven_by :selenium, using: :headless_chrome, screen_size: [1280, 800]
  end

  config.after(type: :system) do
    logs = page.driver.browser.logs.get(:browser)
    errors = logs.select { |log| log.level.in?(%w[SEVERE WARNING]) }
    expect(errors).to(be_blank, errors.map(&:message).join("\n"))
  end
end
