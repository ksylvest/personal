require 'spec_helper'

describe ArchiveController do

  describe 'GET #index' do
    it 'is successful' do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

end
