require 'spec_helper'

feature 'Posts' do

  before(:each) do
    @post = Fabricate(:post)
  end

  scenario 'visiting a page' do
    visit post_path(segment: @post.segment, slug: @post.slug)

    expect(page).to have_content(@post.title)
    expect(page).to have_content(@post.body)
  end

end
