require "spec_helper"

RSpec.describe "Errors" do
  it "renders a page for missing" do
    visit missing_path

    expect(page).to have_text("The page you were looking for does not exist.")
    expect(page).to have_text("You may have mistyped the address or the page may have moved.")
    expect(page).to have_text("If you continue to experience problems please contact us at info@ksylvest.com.")
  end

  it "renders a page for unprocessable" do
    visit unprocessable_path

    expect(page).to have_text("The change you wanted was rejected.")
    expect(page).to have_text("Maybe you tried to change something you do not have access to.")
    expect(page).to have_text("If you continue to experience problems please contact us at info@ksylvest.com.")
  end

  it "renders a page for exception" do
    visit exception_path

    expect(page).to have_text("Something went wrong.")
    expect(page).to have_text("We have been notified of the issue and will try and fix it.")
    expect(page).to have_text("If you continue to experience problems please contact us at info@ksylvest.com.")
  end
end
