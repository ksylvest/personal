require "spec_helper"

RSpec.describe SitemapsController, type: :request do
  describe "GET #show" do
    it "is successful" do
      get sitemap_path(:xml)
      expect(response).to have_http_status(:ok)
    end

    it "includes non-canonical posts and pages" do
      get sitemap_path(:xml)
      expect(response.body).to include("/posts/2024-02-01/ruby-on-rails")
      expect(response.body).to include("/pages/uses")
    end

    it "excludes canonical posts and pages" do
      get sitemap_path(:xml)
      expect(response.body).not_to include("/posts/2024-01-01/swift")
      expect(response.body).not_to include("/pages/drafts")
    end
  end
end
