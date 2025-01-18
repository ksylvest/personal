require "spec_helper"

RSpec.describe PostsController, type: :request do
  let(:post) { create(:post) }

  describe "GET #index" do
    it "is succcesful" do
      get posts_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #show" do
    it "is successful" do
      get post_path(segment: post.segment, slug: post.slug)
      expect(response).to have_http_status(:ok)
    end

    context "with an active post" do
      let(:post) { create(:post, status: Approvable::Status::ACTIVE) }

      it "allows indexing of valid posts" do
        get post_path(segment: post.segment, slug: post.slug)
        expect(response.headers["X-Robots-Tag"]).to be_nil
      end
    end

    context "with an inactive post" do
      let(:post) { create(:post, status: Approvable::Status::PENDING) }

      it "disallows indexing of invalid posts" do
        get post_path(segment: post.segment, slug: post.slug)
        expect(response.headers["X-Robots-Tag"]).to(eql("noindex,nofollow"))
      end
    end
  end
end
