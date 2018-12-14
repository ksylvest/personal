require 'spec_helper'

describe ContactsController do

  describe 'GET #new' do
    it 'assigns all posts as @posts' do
      get :new
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST #create' do
    it 'sends an action mailer with valid parameters' do
      expect {
        post :create, params: {
          contact: {
            name: 'John Smith',
            email: 'john.smith@gmail.com',
            subject: 'Hello',
            message: 'How are you?',
          },
        }
      }.to change { ActionMailer::Base.deliveries.count }
      expect(response).to be_redirect
    end

    it 'does nothing with invalid parameters' do
      expect {
        post :create, params: {
          contact: {
            name: 'John Smith',
            email: 'john.smith',
            subject: 'Hello',
            message: 'How are you?',
          },
        }
      }.to_not change { ActionMailer::Base.deliveries.count }
      expect(response).to have_http_status(:ok)
    end
  end

end
