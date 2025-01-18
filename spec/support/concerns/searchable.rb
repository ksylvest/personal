require "spec_helper"

shared_examples_for "searchable" do
  describe ".search" do
    subject(:search) { described_class.search(query) }

    let(:query) { "Technology" }

    it "searches" do
      expect { search }.not_to raise_error
    end
  end
end
