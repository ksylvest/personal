require 'spec_helper'

RSpec.describe ContactsController, type: :request do
  describe 'GET #new' do
    it 'is successful' do
      get new_contact_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:params) do
        {
          name: 'John Smith',
          email: 'john.smith@gmail.com',
          subject: 'Hello',
          message: 'How are you?',
        }
      end

      it 'schedules a devliery' do
        expect {
          post contact_path, params: { contact: params }
          expect(response).to redirect_to(root_path)
        }.to change { ActionMailer::Base.deliveries.count }
      end
    end

    context 'with invalid parameters' do
      let(:params) do
        {
          name: 'John Smith',
          email: 'john.smith',
          subject: 'Hello',
          message: 'How are you?',
        }
      end

      it 'does not schedule a delivery' do
        expect {
          post contact_path, params: { contact: params }
          expect(response).to have_http_status(:ok)
        }.not_to change { ActionMailer::Base.deliveries.count }
      end
    end
  end
end
