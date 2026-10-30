require "spec_helper"

RSpec.describe Page do
  describe ".all" do
    it "returns pages ordered newest first" do
      expect(Page.all.map(&:slug)).to eql(%w[uses drafts])
    end
  end

  describe ".find" do
    it "returns a page for a known slug" do
      expect(Page.find(slug: "uses")).to have_attributes(
        slug: "uses",
        date: Date.new(2024, 1, 1),
        title: "Uses",
        summary: "The hardware and software I use.",
        tags: %w[setup],
        canonical_url: nil,
        body: "A list of things I use every day."
      )
    end

    it "returns nil for an unknown slug" do
      expect(Page.find(slug: "unknown")).to be_nil
    end
  end

  describe ".find!" do
    it "raises for an unknown slug" do
      expect { Page.find!(slug: "unknown") }.to raise_error(ActionController::RoutingError)
    end
  end

  describe ".search" do
    it "matches every term against the title, summary, and body" do
      expect(Page.search(query: "hardware every day").map(&:slug)).to eql(%w[uses])
    end

    it "returns nothing for a blank query" do
      expect(Page.search(query: " ")).to be_empty
    end
  end

  describe ".tagged" do
    it "filters by tag" do
      expect(Page.tagged(tag: "setup").map(&:slug)).to eql(%w[uses])
    end
  end
end
