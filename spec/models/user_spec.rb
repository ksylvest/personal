require "spec_helper"

RSpec.describe User do
  subject { build(:user) }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :email }

  it { is_expected.to validate_uniqueness_of :email }

  it { is_expected.not_to allow_value("kevin").for(:email) }
  it { is_expected.not_to allow_value("@host.com").for(:email) }
  it { is_expected.not_to allow_value("kevin@host").for(:email) }
  it { is_expected.to allow_value("kevin@host.com").for(:email) }
end
