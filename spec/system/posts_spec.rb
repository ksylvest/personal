require 'spec_helper'

RSpec.describe 'Posts' do
  let(:entry) { create(:post) }

  it 'lets a visitor view a post title and body' do
    visit post_path(slug: entry.slug)

    expect(page).to have_text(entry.title)
    expect(page).to have_text(entry.body)
  end
end
