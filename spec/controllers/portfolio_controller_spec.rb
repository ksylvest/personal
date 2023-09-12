require 'rails_helper'

RSpec.describe PortfolioController, type: :request do
  describe 'GET #index' do
    it 'is succcesful' do
      get portfolio_path
      expect(response).to have_http_status(:ok)
    end
  end
end
