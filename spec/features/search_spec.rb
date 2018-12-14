require 'spec_helper'

feature 'Posts' do

  before(:each) do
    Fabricate(:post, title: 'Beginner Ruby', summary: 'A Beginners Guide to Ruby')
    Fabricate(:post, title: 'Advanced Ruby', summary: 'An Advanced Guide to Ruby')
    Fabricate(:page, title: 'Ruby', summary: 'A Guide to Ruby')
  end

  scenario 'visiting a page' do
    visit search_path

    fill_in 'Search', with: 'Ruby'
    click_button 'Search'

    expect(page).to have_content('Beginner Ruby')
    expect(page).to have_content('Advanced Ruby')
    expect(page).to have_content('A Guide to Ruby')
  end

end
