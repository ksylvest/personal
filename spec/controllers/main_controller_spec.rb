require 'spec_helper'

describe MainController do

  %w[about contact projects portfolio].each do |page|

    describe "GET ##{page}" do
      it 'should be successful' do
        get page
        expect(response).to have_http_status(:ok)
      end
    end

  end

end
