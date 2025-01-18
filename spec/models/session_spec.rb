require "spec_helper"

RSpec.describe Session do
  let(:user) { create(:user) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:password) }

  it { is_expected.not_to allow_value("kevin").for(:email) }
  it { is_expected.not_to allow_value("@host.com").for(:email) }
  it { is_expected.to allow_value("kevin@host.com").for(:email) }

  describe "#authenticate" do
    it "returns a user if authed" do
      session = Session.new(email: user.email, password: user.password)
      expect(session.authenticate).to eq(user)
      expect(session.errors).to be_blank
    end

    it "returns a nil if not authed" do
      session = Session.new(email: user.email, password: user.password.reverse)
      expect(session.authenticate).to be_nil
      expect(session.errors).to be_present
    end
  end
end
