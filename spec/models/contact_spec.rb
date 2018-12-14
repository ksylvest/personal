require 'spec_helper'

describe Contact do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:subject) }
  it { should validate_presence_of(:message) }
end
