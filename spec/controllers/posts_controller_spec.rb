require "spec_helper"

RSpec.describe PostsController, type: :request do
  describe "GET #index" do
    it "is succcesful" do
      get posts_path
      expect(response).to have_http_status(:ok)
    end

    it "is successful with a tag" do
      get posts_path(tag: "ruby")
      expect(response).to have_http_status(:ok)
    end

    it "redirects for an unknown tag" do
      get posts_path(tag: "unknown")
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET #show" do
    context "with a known post" do
      let(:post) { Post.find!(slug: "swift") }

      it "is successful" do
        get post_path(segment: post.segment, slug: post.slug)
        expect(response).to have_http_status(:ok)
      end
    end

    context "with an unknown post" do
      it "is not found" do
        get post_path(segment: "2024-01-01", slug: "unknown")
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
