require 'spec_helper'

describe MainController do
  describe 'routing' do

    it 'routes to #about' do
      expect(get: '/about').to route_to('main#about')
    end

    it 'routes to #contact' do
      expect(get: '/contact').to route_to('main#contact')
    end

    it 'routes to #projects' do
      expect(get: '/projects').to route_to('main#projects')
    end

  end
end
