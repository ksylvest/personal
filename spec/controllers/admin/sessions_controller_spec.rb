require 'spec_helper'

describe Admin::SessionsController do

  let(:user) { Fabricate(:user, role: 'admin') }

  before :each do
    request.env['HTTPS'] = 'on'
  end

  describe 'GET #new' do
    it 'should require deauthentication' do
      authenticate user
      get 'new'
      should_deauthenticate!
    end

    it 'should be successful if deauthenticated' do
      deauthenticate
      get 'new'
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST #create' do
    it 'should require deauthentication' do
      authenticate user
      get 'new'
      should_deauthenticate!
    end

    it 'should create a session with valid parameters' do
      deauthenticate
      post :create, params: { session: { email: user.email, password: user.password } }
      expect(response).to be_redirect
    end

    it 'should render template with invalid parameters' do
      deauthenticate
      post :create, params: { session: { email: user.password, password: user.email } }
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'DELETE #destroy' do
    it 'should require authentication' do
      deauthenticate
      delete :destroy
      should_admin!
    end

    it 'should be successful if authenticated' do
      authenticate user
      delete :destroy
      expect(response).to be_redirect
    end
  end

end
