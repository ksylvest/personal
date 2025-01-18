require "spec_helper"

RSpec.describe "Pages" do
  let(:entry) { create(:page) }

  it "lets a visitor view a page title and body" do
    visit page_path(slug: entry.slug)

    expect(page).to have_text(entry.title)
    expect(page).to have_text(entry.body)
  end
end
