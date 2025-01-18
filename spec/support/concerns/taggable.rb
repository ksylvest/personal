require "spec_helper"

shared_examples_for "taggable" do
  describe "#taggables=" do
    it "splits a value into tags" do
      subject.taggables = "ruby rack"
      expect(subject.tags).to eql(%w[ruby rack])
    end
  end

  describe "#taggables" do
    it "joins tags into a value" do
      subject.tags = %w[ruby rack]
      expect(subject.taggables).to eq("ruby rack")
    end
  end
end
