require "spec_helper"

RSpec.describe SitemapsController, type: :request do
  describe "GET #show" do
    it "is successful" do
      get sitemap_path(:xml)
      expect(response).to have_http_status(:ok)
    end
  end
end
