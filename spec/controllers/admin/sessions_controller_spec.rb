require "spec_helper"

RSpec.describe Admin::SessionsController, type: :request do
  let(:user) { create(:user, role: "admin") }

  describe "GET #new" do
    it "is successful" do
      get new_admin_session_url
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "authenticates" do
        post admin_session_url, params: { session: { email: user.email, password: user.password } }
        expect(response).to redirect_to(admin_path)
      end
    end

    context "with invalid parameters" do
      it "does not authenticate" do
        post admin_session_url, params: { session: { email: user.password, password: user.email } }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "DELETE #destroy" do
    it "deauthenticates" do
      authenticate user
      delete admin_session_url
      expect(response).to be_redirect
    end
  end
end
