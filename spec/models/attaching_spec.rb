require 'spec_helper'

describe Attaching do
  it { should belong_to(:attachment) }
  it { should belong_to(:document) }
end
