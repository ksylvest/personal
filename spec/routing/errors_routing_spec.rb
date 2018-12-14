require 'spec_helper'

describe ErrorsController do
  describe 'routing' do

    it 'routes to #missing' do
      expect(get: '/404').to route_to('errors#missing')
    end

    it 'routes to #unprocessable' do
      expect(get: '/422').to route_to('errors#unprocessable')
    end

    it 'routes to #exception' do
      expect(get: '/500').to route_to('errors#exception')
    end

  end
end
