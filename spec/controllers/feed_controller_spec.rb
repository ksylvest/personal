require 'spec_helper'

describe FeedController do

  describe 'GET #index' do
    it 'is successful' do
      get :index, format: :atom
      expect(response).to have_http_status(:ok)
    end
  end

end
