require 'spec_helper'

RSpec.describe Session, type: :model do
  let(:user) { create(:user) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:password) }

  it { is_expected.not_to allow_value('kevin').for(:email) }
  it { is_expected.not_to allow_value('@host.com').for(:email) }
  it { is_expected.to allow_value('kevin@host.com').for(:email) }

  it 'authenticates' do
    session = Session.new(email: user.email, password: user.password)
    expect(session.user).to eq(user)
  end

  describe 'persisted?' do
    it 'is "false" if unauthenticated' do
      session = Session.new
      expect(session).not_to be_persisted
    end
    it 'is "true" if authenticated' do
      session = Session.new(email: user.email, password: user.password)
      expect(session).to be_persisted
    end
  end
end
