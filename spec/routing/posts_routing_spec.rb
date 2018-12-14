require 'spec_helper'

describe PostsController do
  describe 'routing' do

    it 'routes to #index' do
      expect(get: '/').to route_to('posts#index')
      expect(get: '/page/1').to route_to('posts#index', page: '1')
      expect(get: '/page/2').to route_to('posts#index', page: '2')
    end

    it 'routes to #show' do
      expect(get: '/posts/2012-12-31/ruby').to route_to('posts#show', segment: '2012-12-31', slug: 'ruby')
      expect(get: '/posts/2012-12-31/java').to route_to('posts#show', segment: '2012-12-31', slug: 'java')
    end

  end
end
