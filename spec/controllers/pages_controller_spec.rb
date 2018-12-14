require 'spec_helper'

describe PagesController do

  describe 'GET #show' do
    it 'assigns the requested page as @page' do
      page = Fabricate(:page)
      get :show, params: { slug: page.slug }
      expect(assigns(:page)).to eq(page)
    end
  end

end
