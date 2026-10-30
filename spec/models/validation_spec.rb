require "spec_helper"

RSpec.describe Validation do
  it "validates urls" do
    expect(Validation::URL).to match("https://ksylvest.com")
    expect(Validation::URL).not_to match("ksylvest.com")
  end
end
