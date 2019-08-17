require 'spec_helper'

RSpec.describe ErrorsController, type: :request do
  describe 'GET #missing' do
    it 'renders the correct status code' do
      get missing_path
      expect(response).to have_http_status(404)
    end
  end

  describe 'GET #unprocessable' do
    it 'renders the correct status code' do
      get unprocessable_path
      expect(response).to have_http_status(422)
    end
  end

  describe 'GET #exception' do
    it 'renders the correct status code' do
      get exception_path
      expect(response).to have_http_status(500)
    end
  end
end
