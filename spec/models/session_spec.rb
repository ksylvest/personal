require 'spec_helper'

describe Session do

  let(:user) { Fabricate(:user) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }

  it { should_not allow_value('kevin').for(:email) }
  it { should_not allow_value('@host.com').for(:email) }
  it { should allow_value('kevin@host.com').for(:email) }

  it 'should authenticate' do
    session = Session.new(email: user.email, password: user.password)
    expect(session.user).to eq(user)
  end

  describe 'persisted?' do
    it 'is "false" if unauthenticated' do
      session = Session.new
      expect(session.persisted?).to be_falsey
    end
    it 'is "true" if authenticated' do
      session = Session.new(email: user.email, password: user.password)
      expect(session.persisted?).to be_truthy
    end
  end
end
