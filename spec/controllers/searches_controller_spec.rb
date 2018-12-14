require 'spec_helper'

describe SearchesController do

  describe 'GET #show' do

    it 'assigns a search' do
      get :show
      assigns(:search)
    end

    it 'uses the correct query' do
      get :show, params: { search: { query: 'Ruby' } }
      expect(assigns(:search).query).to eql('Ruby')
    end

    it 'assigns a subset of posts as @posts' do
      match = Fabricate(:post, title: 'Ruby')
      Fabricate(:post, title: 'Python')
      get :show, params: { search: { query: 'Ruby' } }
      expect(assigns(:posts)).to include(match)
    end

    it 'assigns a subset of pages to @pages' do
      match = Fabricate(:page, title: 'Ruby')
      Fabricate(:page, title: 'Python')
      get :show, params: { search: { query: 'Ruby' } }
      expect(assigns(:pages)).to include(match)
    end
  end

end
