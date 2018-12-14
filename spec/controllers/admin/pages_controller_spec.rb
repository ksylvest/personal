require 'spec_helper'

describe Admin::PagesController do

  let(:user) { Fabricate(:user, role: 'admin') }
  let(:invalid) { { title: '', body: '' } }
  let(:attributes) { { title: 'Ruby', summary: 'Ruby', body: 'Ruby...' } }

  before(:each) do
    authenticate(user)
  end

  describe 'GET #index' do
    it 'assigns all pages as @pages' do
      page = Fabricate(:page, user: user)
      get :index
      expect(assigns(:pages)).to include(page)
    end
  end

  describe 'GET #new' do
    it 'assigns a new page as @page' do
      get :new
      expect(assigns(:page)).to be_a_new(Page)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested page as @page' do
      page = Fabricate(:page, user: user)
      get :edit, params: { id: page.id }
      expect(assigns(:page)).to eq(page)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Page' do
        expect {
          post :create, params: { page: attributes }
        }.to change(Page, :count)
      end

      it 'assigns a newly created page as @page' do
        post :create, params: { page: attributes }
        expect(assigns(:page)).to be_a(Page)
        expect(assigns(:page)).to be_persisted
      end

      it 'redirects to the created page' do
        post :create, params: { page: attributes }
        expect(response).to redirect_to(admin_pages_path)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved page as @page' do
        post :create, params: { page: invalid }
        expect(assigns(:page)).to be_a_new(Page)
      end

      it 're-renders the "new" template' do
        post :create, params: { page: invalid }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT update' do
    context 'with valid params' do
      it 'assigns the requested page as @page' do
        page = Fabricate(:page, user: user)
        put :update, params: { id: page.id, page: attributes }
        expect(assigns(:page)).to eq(page)
      end

      it 'redirects to the page' do
        page = Fabricate(:page, user: user)
        put :update, params: { id: page.id, page: attributes }
        expect(response).to redirect_to(admin_pages_path)
      end
    end

    context 'with invalid params' do
      it 'assigns the page as @page' do
        page = Fabricate(:page, user: user)
        put :update, params: { id: page.id, page: invalid }
        expect(assigns(:page)).to eq(page)
      end

      it 'renders the "edit" template' do
        page = Fabricate(:page, user: user)
        put :update, params: { id: page.id, page: invalid }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested page' do
      page = Fabricate(:page, user: user)
      expect {
        delete :destroy, params: { id: page.id }
      }.to change(Page, :count).by(-1)
    end

    it 'redirects to the pages list' do
      page = Fabricate(:page, user: user)
      delete :destroy, params: { id: page.id }
      expect(response).to redirect_to(admin_pages_path)
    end
  end
end
