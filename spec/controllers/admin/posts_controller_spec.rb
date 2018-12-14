require 'spec_helper'

describe Admin::PostsController do

  let(:user) { Fabricate(:user, role: 'admin') }
  let(:invalid) { { title: '', body: '' } }
  let(:attributes) { { title: 'Ruby', summary: 'Ruby', body: 'Ruby...' } }

  before(:each) do
    authenticate(user)
  end

  describe 'GET #index' do
    it 'assigns all posts as @posts' do
      post = Fabricate(:post, user: user)
      get :index
      expect(assigns(:posts)).to include(post)
    end
  end

  describe 'GET #new' do
    it 'assigns a new post as @post' do
      get :new
      expect(assigns(:post)).to be_a_new(Post)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested post as @post' do
      post = Fabricate(:post, user: user)
      get :edit, params: { id: post.id }
      expect(assigns(:post)).to eq(post)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Post' do
        expect {
          post :create, params: { post: attributes }
        }.to change(Post, :count)
      end

      it 'assigns a newly created post as @post' do
        post :create, params: { post: attributes }
        expect(assigns(:post)).to be_a(Post)
        expect(assigns(:post)).to be_persisted
      end

      it 'redirects to the created post' do
        post :create, params: { post: attributes }
        expect(response).to redirect_to(admin_posts_path)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved post as @post' do
        post :create, params: { post: invalid }
        expect(assigns(:post)).to be_a_new(Post)
      end

      it 're-renders the "new" template' do
        post :create, params: { post: invalid }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT update' do
    context 'with valid params' do
      it 'assigns the requested post as @post' do
        post = Fabricate(:post, user: user)
        put :update, params: { id: post.id, post: attributes }
        expect(assigns(:post)).to eq(post)
      end

      it 'redirects to the post' do
        post = Fabricate(:post, user: user)
        put :update, params: { id: post.id, post: attributes }
        expect(response).to redirect_to(admin_posts_path)
      end
    end

    context 'with invalid params' do
      it 'assigns the post as @post' do
        post = Fabricate(:post, user: user)
        put :update, params: { id: post.id, post: invalid }
        expect(assigns(:post)).to eq(post)
      end

      it 'renders the "edit" template' do
        post = Fabricate(:post, user: user)
        put :update, params: { id: post.id, post: invalid }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested post' do
      post = Fabricate(:post, user: user)
      expect {
        delete :destroy, params: { id: post.id }
      }.to change(Post, :count).by(-1)
    end

    it 'redirects to the posts list' do
      post = Fabricate(:post, user: user)
      delete :destroy, params: { id: post.id }
      expect(response).to redirect_to(admin_posts_path)
    end
  end
end
