require 'spec_helper'

describe Admin::AttachmentsController do

  let(:user) { Fabricate(:user, role: 'admin') }
  let(:invalid) { { file: fixture_file_upload('attachment'), name: '' } }
  let(:attributes) { { file: fixture_file_upload('attachment'), name: 'Ruby...' } }

  before(:each) do
    authenticate(user)
  end

  describe 'GET #index' do
    it 'assigns all attachments as @attachments' do
      attachment = Fabricate(:attachment)
      get :index
      expect(assigns(:attachments)).to include(attachment)
    end
  end

  describe 'GET #new' do
    it 'assigns a new attachment as @attachment' do
      get :new
      expect(assigns(:attachment)).to be_a_new(Attachment)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested attachment as @attachment' do
      attachment = Fabricate(:attachment)
      get :edit, params: { id: attachment.id }
      expect(assigns(:attachment)).to eq(attachment)
    end
  end

  describe 'POST #create' do
    describe 'with valid params' do
      it 'creates a new attachment' do
        expect {
          post :create, params: { attachment: attributes }
        }.to change(Attachment, :count)
      end

      it 'assigns a newly created attachment as @attachment' do
        post :create, params: { attachment: attributes }
        expect(assigns(:attachment)).to be_a(Attachment)
        expect(assigns(:attachment)).to be_persisted
      end

      it 'redirects to the created attachment' do
        post :create, params: { attachment: attributes }
        expect(response).to redirect_to(admin_attachments_path)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved attachment as @attachment' do
        post :create, params: { attachment: invalid }
        expect(assigns(:attachment)).to be_a_new(Attachment)
      end

      it 're-renders the "new" template' do
        post :create, params: { attachment: invalid }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'assigns the requested attachment as @attachment' do
        attachment = Fabricate(:attachment)
        put :update, params: { id: attachment.id, attachment: attributes }
        expect(assigns(:attachment)).to eq(attachment)
      end

      it 'redirects to the attachment' do
        attachment = Fabricate(:attachment)
        put :update, params: { id: attachment.id, attachment: attributes }
        expect(response).to redirect_to(admin_attachments_path)
      end
    end

    describe 'with invalid params' do
      it 'assigns the attachment as @attachment' do
        attachment = Fabricate(:attachment)
        put :update, params: { id: attachment.id, attachment: invalid }
        expect(assigns(:attachment)).to eq(attachment)
      end

      it 'renders the "edit" template' do
        attachment = Fabricate(:attachment)
        put :update, params: { id: attachment.id, attachment: invalid }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested attachment' do
      attachment = Fabricate(:attachment)
      expect {
        delete :destroy, params: { id: attachment.id }
      }.to change(Attachment, :count).by(-1)
    end

    it 'redirects to the attachments list' do
      attachment = Fabricate(:attachment)
      delete :destroy, params: { id: attachment.id }
      expect(response).to redirect_to(admin_attachments_path)
    end
  end
end
