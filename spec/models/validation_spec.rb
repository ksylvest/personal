require "spec_helper"

RSpec.describe Validation do
  it "validates urls" do
    expect(Validation::URL).to match("https://ksylvest.com")
    expect(Validation::URL).not_to match("ksylvest.com")
  end

  it "validates emails" do
    expect(Validation::EMAIL).to match("kevin@ksylvest.com")
    expect(Validation::EMAIL).not_to match("kevin")
  end

  it "validates permalinks" do
    expect(Validation::PERMALINK).to match("2014-12-31-something")
    expect(Validation::PERMALINK).not_to match("2014 12 31 something")
  end
end
