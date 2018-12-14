require 'spec_helper'

describe PostsController do

  describe 'GET #index' do
    it 'assigns all posts as @posts' do
      post = Fabricate(:post)
      get :index
      expect(assigns(:posts)).to include(post)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested post as @post' do
      post = Fabricate(:post)
      get :show, params: { segment: post.segment, slug: post.slug }
      expect(assigns(:post)).to eq(post)
    end

    it 'allows indexing of valid posts' do
      post = Fabricate(:post, status: Approvable::Status::ACTIVE)
      get :show, params: { segment: post.segment, slug: post.slug }
      should_robot
    end

    it 'disallows indexing of invalid posts' do
      post = Fabricate(:post, status: Approvable::Status::PENDING)
      get :show, params: { segment: post.segment, slug: post.slug }
      should_norobot
    end
  end

end
