require 'spec_helper'

RSpec.describe ErrorsController, type: :request do
  describe 'GET #missing' do
    it 'renders the correct status code' do
      get missing_path
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'GET #unprocessable' do
    it 'renders the correct status code' do
      get unprocessable_path
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe 'GET #exception' do
    it 'renders the correct status code' do
      get exception_path
      expect(response).to have_http_status(:internal_server_error)
    end
  end
end
