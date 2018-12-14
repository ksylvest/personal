require 'spec_helper'

describe Admin::DashboardController do

  let(:admin) { Fabricate(:user, role: 'admin') }

  before(:each) do
    authenticate(admin)
  end

  describe 'GET #index' do
    it 'returns http success' do
      get 'index'
      expect(response).to have_http_status(:ok)
    end
  end

end
