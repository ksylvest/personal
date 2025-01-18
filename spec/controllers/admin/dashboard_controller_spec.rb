require "spec_helper"

RSpec.describe Admin::DashboardController, type: :request do
  let(:user) { create(:user, role: "admin") }

  before { authenticate(user) }

  describe "GET #index" do
    it "is successful" do
      get admin_path
      expect(response).to have_http_status(:ok)
    end
  end
end
