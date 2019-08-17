require 'spec_helper'

RSpec.describe Attaching, type: :model do
  it { is_expected.to belong_to(:attachment) }
  it { is_expected.to belong_to(:document) }
end
