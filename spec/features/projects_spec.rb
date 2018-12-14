require 'spec_helper'

feature 'Project' do

  before(:each) do
    @page = Fabricate(:page)
  end

  scenario 'visiting a page' do
    visit projects_path

    Project.all.each do |project|
      expect(page).to have_link(project.name, href: project.url)
    end
  end

end
