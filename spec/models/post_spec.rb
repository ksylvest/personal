require "spec_helper"

RSpec.describe Post do
  describe ".all" do
    it "returns posts ordered newest first" do
      expect(described_class.all.map(&:slug)).to eql(%w[ruby-on-rails swift])
    end
  end

  describe ".find" do
    it "returns a post for a known slug" do
      expect(described_class.find(slug: "ruby-on-rails")).to have_attributes(
        slug: "ruby-on-rails",
        date: Date.new(2024, 2, 1),
        title: "Ruby on Rails",
        summary: "Rails is a web application framework.",
        tags: %w[rails ruby],
        canonical_url: nil,
        body: "Rails makes building web applications delightful."
      )
    end

    it "returns nil for an unknown slug" do
      expect(described_class.find(slug: "unknown")).to be_nil
    end
  end

  describe ".find!" do
    it "returns a post for a known slug" do
      expect(described_class.find!(slug: "swift")).to have_attributes(
        slug: "swift",
        date: Date.new(2024, 1, 1),
        title: "Swift",
        summary: "Swift is a statically typed language.",
        tags: %w[swift],
        canonical_url: "https://example.com/swift",
        body: "Swift is used to build apps for iOS and macOS."
      )
    end

    it "raises for an unknown slug" do
      expect { described_class.find!(slug: "unknown") }.to raise_error(ActionController::RoutingError)
    end
  end

  describe ".tagged" do
    it "filters by tag" do
      expect(described_class.tagged(tag: "swift").map(&:slug)).to eql(%w[swift])
    end

    it "returns all posts without a tag" do
      expect(described_class.tagged(tag: nil).map(&:slug)).to eql(%w[ruby-on-rails swift])
    end
  end

  describe ".search" do
    it "matches every term against the title, summary, and body" do
      expect(described_class.search(query: "rails delightful").map(&:slug)).to eql(%w[ruby-on-rails])
    end

    it "ignores case" do
      expect(described_class.search(query: "SWIFT").map(&:slug)).to eql(%w[swift])
    end

    it "excludes posts missing a term" do
      expect(described_class.search(query: "rails swift")).to be_empty
    end
  end

  describe "#segment" do
    it "formats the date" do
      expect(described_class.find!(slug: "ruby-on-rails").segment).to eql("2024-02-01")
    end
  end

  describe "#keywords" do
    it "joins the tags" do
      expect(described_class.find!(slug: "ruby-on-rails").keywords).to eql("rails,ruby")
    end
  end
end
