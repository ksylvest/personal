require 'spec_helper'

RSpec.describe 'Search', type: :system do
  let(:post) { Fabricate(:post) }

  it 'filters post when searching' do
    visit search_path

    fill_in 'Search', with: post.title
    click_button 'Search'

    expect(page).to have_text(post.title)
  end
end
