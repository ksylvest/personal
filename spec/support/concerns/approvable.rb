require "spec_helper"

shared_examples_for "approvable" do
  describe "active?" do
    it 'is active if the status is "active"' do
      subject.status = Approvable::Status::ACTIVE
      expect(subject).to be_active
    end
  end

  describe "pending?" do
    it 'is pending if the status is "pending"' do
      subject.status = Approvable::Status::PENDING
      expect(subject).to be_pending
    end
  end
end
