require 'spec_helper'

describe FeedController do
  describe 'routing' do

    it 'routes to #feed' do
      expect(get: '/feed').to route_to('feed#index')
    end

  end
end
