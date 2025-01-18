require "spec_helper"

RSpec.describe Search do
  subject(:search) { Search.new(query) }

  let!(:page) { create(:page, title: query) }
  let!(:post) { create(:post, title: query) }
  let(:query) { "Ruby" }

  describe "#pages" do
    it "searches pages" do
      expect(search.pages).to include(page)
    end
  end

  describe "#posts" do
    it "searches posts" do
      expect(search.posts).to include(post)
    end
  end
end
