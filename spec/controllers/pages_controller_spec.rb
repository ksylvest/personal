require "spec_helper"

RSpec.describe PagesController, type: :request do
  let(:page) { create(:page) }

  describe "GET #show" do
    it "is successful" do
      get page_path(slug: page.slug)
      expect(response).to have_http_status(:ok)
    end
  end
end
