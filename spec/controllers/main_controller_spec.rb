require "spec_helper"

RSpec.describe MainController, type: :request do
  describe "GET #about" do
    it "is successful" do
      get about_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #contact" do
    it "is successful" do
      get contact_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #projects" do
    it "is successful" do
      get projects_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #portfolio" do
    it "is successful" do
      get portfolio_path
      expect(response).to have_http_status(:ok)
    end
  end
end
