require 'spec_helper'

describe ErrorsController do

  describe 'GET #missing' do
    it 'renders the correct status code' do
      get :missing
      expect(response.status).to eql(404)
    end
  end

  describe 'GET #unprocessable' do
    it 'renders the correct status code' do
      get :unprocessable
      expect(response.status).to eql(422)
    end
  end

  describe 'GET #exception' do
    it 'renders the correct status code' do
      get :exception
      expect(response.status).to eql(500)
    end
  end

end
