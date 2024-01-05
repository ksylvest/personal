require 'spec_helper'

RSpec.describe 'Search' do
  let(:searchables) do
    [
      create(:page, title: 'Rails', summary: 'Rails is a web application framework.'),
      create(:post, title: 'swift', summary: 'Swift is a statically typed language.'),
    ]
  end

  it 'filters post when searching' do
    visit search_path

    searchables.each do |entry|
      fill_in('Search', with: entry.title)
      click_on('Search')
      expect(page).to have_text(entry.title)
      expect(page).to have_text(entry.summary)
    end
  end
end
