require 'spec_helper'

describe PagesController do
  describe 'routing' do

    it 'routes to #show' do
      expect(get: '/pages/fun').to route_to('pages#show', slug: 'fun')
      expect(get: '/pages/sun').to route_to('pages#show', slug: 'sun')
    end

  end
end
