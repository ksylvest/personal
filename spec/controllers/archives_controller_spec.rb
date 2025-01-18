require "spec_helper"

RSpec.describe ArchivesController, type: :request do
  describe "GET #show" do
    it "is successful" do
      get archive_path
      expect(response).to have_http_status(:ok)
    end
  end
end
