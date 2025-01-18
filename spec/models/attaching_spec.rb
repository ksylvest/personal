require "spec_helper"

RSpec.describe Attaching do
  it { is_expected.to belong_to(:attachment) }
  it { is_expected.to belong_to(:document) }
end
