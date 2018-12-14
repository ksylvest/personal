require 'spec_helper'

describe SitemapController do
  describe 'routing' do

    it 'routes to #index' do
      expect(get: '/sitemap').to route_to('sitemap#index')
    end

  end
end
