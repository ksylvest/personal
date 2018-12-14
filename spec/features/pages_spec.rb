require 'spec_helper'

feature 'Pages' do

  before(:each) do
    @page = Fabricate(:page)
  end

  scenario 'visiting a page' do
    visit page_path(slug: @page.slug)

    expect(page).to have_content(@page.title)
    expect(page).to have_content(@page.body)
  end

end
