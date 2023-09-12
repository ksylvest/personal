require 'spec_helper'

RSpec.describe Portfolio do
  subject { build(:portfolio) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:summary) }
  it { is_expected.to have_many_attached(:images) }
end
