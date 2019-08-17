require 'spec_helper'

RSpec.describe Admin::PagesController, type: :request do
  let!(:entry) { Fabricate(:page, user: user) }
  let(:user) { Fabricate(:user, role: 'admin') }
  let(:valid_attributes) { { title: 'Ruby', summary: 'Ruby', body: 'Ruby...' } }
  let(:invalid_attributes) { { title: '', body: '' } }

  before { authenticate(user) }

  describe 'GET #index' do
    it 'is successful' do
      get admin_pages_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #new' do
    it 'is successful' do
      get new_admin_page_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #edit' do
    it 'is successful' do
      get edit_admin_page_path(entry)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'saves' do
        expect {
          post admin_pages_path, params: { page: valid_attributes }
          expect(response).to redirect_to(admin_pages_path)
        }.to change(Page, :count)
      end
    end

    context 'with invalid params' do
      it 'does not' do
        expect {
          post admin_pages_path, params: { page: invalid_attributes }
          expect(response).to have_http_status(:ok)
        }.not_to change(Page, :count)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid params' do
      it 'saves' do
        expect {
          patch admin_page_path(entry), params: { page: valid_attributes }
          expect(response).to redirect_to(admin_pages_path)
        }.to change { entry.reload.title }
      end
    end

    context 'with invalid params' do
      it 'does not save' do
        expect {
          patch admin_page_path(entry), params: { page: invalid_attributes }
          expect(response).to have_http_status(:ok)
        }.not_to change { entry.reload.title }
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys' do
      expect {
        delete admin_page_path(entry)
        expect(response).to redirect_to(admin_pages_path)
      }.to change(Page, :count).by(-1)
    end
  end
end
