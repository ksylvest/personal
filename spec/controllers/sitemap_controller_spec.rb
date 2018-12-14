require 'spec_helper'

describe SitemapController do

  describe 'GET #index' do
    it 'is successful' do
      get :index, format: :xml
      expect(response).to have_http_status(:ok)
    end
  end

end
