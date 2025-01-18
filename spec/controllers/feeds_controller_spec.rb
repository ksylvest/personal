require "spec_helper"

RSpec.describe FeedsController, type: :request do
  describe "GET #show" do
    it "is successful" do
      get feed_path(format: :atom)
      expect(response).to have_http_status(:ok)
    end
  end
end
