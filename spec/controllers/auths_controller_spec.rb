require "spec_helper"

RSpec.describe AuthsController, type: :request do
  let(:user) { create(:user) }

  describe "POST #create" do
    it "is successful" do
      authenticate(user)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "DELETE #destroy" do
    it "is successful" do
      deauthenticate
      expect(response).to have_http_status(:ok)
    end
  end
end
