require 'spec_helper'

describe User do
  subject { Fabricate.build(:user) }

  it { should validate_presence_of :name }
  it { should validate_presence_of :email }

  it { should validate_uniqueness_of :email }

  it { should_not allow_value('kevin').for(:email) }
  it { should_not allow_value('@host.com').for(:email) }
  it { should_not allow_value('kevin@host').for(:email) }
  it { should allow_value('kevin@host.com').for(:email) }
end
