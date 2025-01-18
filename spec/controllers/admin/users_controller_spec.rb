require "spec_helper"

RSpec.describe Admin::UsersController, type: :request do
  let(:user) { create(:user, role: User::Role::ADMIN) }

  before { authenticate(user) }

  describe "GET #edit" do
    it "is successful" do
      get edit_admin_user_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      it "saves the user" do
        expect {
          patch admin_user_path, params: { user: { name: user.name.reverse } }
          expect(response).to redirect_to(admin_path)
        }.to change { user.reload.name }
      end
    end

    context "with invalid parameters" do
      it "does not save the user" do
        expect {
          patch admin_user_path, params: { user: { name: "" } }
          expect(response).to have_http_status(:unprocessable_content)
        }.not_to change { user.reload.name }
      end
    end
  end
end
