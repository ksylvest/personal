require 'spec_helper'

RSpec.describe Admin::PostsController, type: :request do
  let!(:entry) { create(:post, user:) }
  let(:user) { create(:user, role: 'admin') }
  let(:valid_attributes) { { title: 'Sorbet', summary: 'Sorbet', body: 'Sorbet...' } }
  let(:invalid_attributes) { { title: '', body: '' } }

  before { authenticate(user) }

  describe 'GET #index' do
    it 'is successful' do
      get admin_posts_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #new' do
    it 'is successful' do
      get new_admin_post_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested post as @post' do
      get edit_admin_post_path(entry)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'saves a post' do
        expect {
          post admin_posts_path, params: { post: valid_attributes }
          expect(response).to redirect_to(admin_posts_path)
        }.to change(Post, :count)
      end
    end

    context 'with invalid params' do
      it 'does not save a post' do
        expect {
          post admin_posts_path, params: { post: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_content)
        }.not_to change(Post, :count)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid params' do
      it 'saves the post' do
        expect {
          patch admin_post_path(entry), params: { post: valid_attributes }
          expect(response).to redirect_to(admin_posts_path)
        }.to change { entry.reload.title }
      end
    end

    context 'with invalid params' do
      it 'does not save the page' do
        expect {
          patch admin_post_path(entry), params: { post: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_content)
        }.not_to change { entry.reload.title }
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys' do
      expect {
        delete admin_post_path(entry)
        expect(response).to redirect_to(admin_posts_path)
      }.to change(Post, :count).by(-1)
    end
  end
end
