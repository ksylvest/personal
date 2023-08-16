require 'spec_helper'

RSpec.describe Attachment do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to have_many(:attachings) }
end
