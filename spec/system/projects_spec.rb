require "spec_helper"

RSpec.describe "Projects" do
  it "links to every project entry" do
    visit projects_path

    Project.all.each do |project|
      expect(page).to have_link(project.name, href: project.url)
    end
  end
end
