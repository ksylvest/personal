require "spec_helper"

RSpec.describe Search do
  subject(:search) { Search.new(query) }

  context "with a query matching a post" do
    let(:query) { "rails framework" }

    it "includes matching posts" do
      expect(search.posts.map(&:slug)).to eql(%w[ruby-on-rails])
    end

    it "excludes non-matching pages" do
      expect(search.pages).to be_empty
    end
  end

  context "with a query matching a page" do
    let(:query) { "Hardware" }

    it "includes matching pages" do
      expect(search.pages.map(&:slug)).to eql(%w[uses])
    end

    it "excludes non-matching posts" do
      expect(search.posts).to be_empty
    end
  end

  context "without a query" do
    let(:query) { nil }

    it "returns nothing" do
      expect(search.posts).to be_nil
      expect(search.pages).to be_nil
    end
  end
end
