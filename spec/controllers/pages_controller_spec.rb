require "spec_helper"

RSpec.describe PagesController, type: :request do
  describe "GET #show" do
    it "is successful" do
      get page_path(slug: "uses")
      expect(response).to have_http_status(:ok)
    end

    it "is not found for an unknown page" do
      get page_path(slug: "unknown")
      expect(response).to have_http_status(:not_found)
    end
  end
end
