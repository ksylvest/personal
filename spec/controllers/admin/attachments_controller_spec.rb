require 'spec_helper'

RSpec.describe Admin::AttachmentsController, type: :request do
  let!(:attachment) { create(:attachment) }
  let(:user) { create(:user, role: 'admin') }
  let(:invalid_attributes) { { file: fixture_file_upload('spec/fixtures/attachment'), name: '' } }
  let(:valid_attributes) { { file: fixture_file_upload('spec/fixtures/attachment'), name: 'Ruby...' } }

  before { authenticate(user) }

  describe 'GET #index' do
    it 'is successful' do
      get admin_attachments_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #new' do
    it 'is successful' do
      get new_admin_attachment_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #edit' do
    it 'is successful' do
      get edit_admin_attachment_path(attachment)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST #create' do
    describe 'with valid params' do
      it 'saves' do
        expect {
          post admin_attachments_path, params: { attachment: valid_attributes }
          expect(response).to redirect_to(admin_attachments_path)
        }.to change(Attachment, :count)
      end
    end

    describe 'with invalid params' do
      it 'does not save' do
        expect {
          post admin_attachments_path, params: { attachment: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_content)
        }.not_to change(Attachment, :count)
      end
    end
  end

  describe 'PATCH #update' do
    describe 'with valid params' do
      it 'saves' do
        expect {
          patch admin_attachment_path(attachment), params: { attachment: valid_attributes }
          expect(response).to redirect_to(admin_attachments_path)
        }.to change { attachment.reload.name }
      end
    end

    describe 'with invalid params' do
      it 'does not save' do
        expect {
          patch admin_attachment_path(attachment), params: { attachment: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_content)
        }.not_to change { attachment.reload.name }
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys' do
      expect {
        delete admin_attachment_path(attachment)
        expect(response).to redirect_to(admin_attachments_path)
      }.to change(Attachment, :count).by(-1)
    end
  end
end
