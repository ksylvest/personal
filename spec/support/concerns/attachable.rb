require "spec_helper"

shared_examples_for "attachable" do
  describe "#attachments" do
    it "attaches using a the link syntax provided by markdown" do
      attachment = create(:attachment)
      subject.summary = "![attachment](attachment:#{attachment.id}:original)"
      subject.attach!

      expect(subject.attachments).to include(attachment)
    end
  end
end
