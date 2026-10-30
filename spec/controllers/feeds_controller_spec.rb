require "spec_helper"

RSpec.describe FeedsController, type: :request do
  describe "GET #show" do
    %i[atom rss].each do |format|
      it "is successful for #{format}" do
        get feed_path(format:)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Ruby on Rails")
      end
    end
  end
end
