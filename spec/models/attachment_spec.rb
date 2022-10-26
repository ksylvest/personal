require 'spec_helper'

RSpec.describe Attachment do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to have_many(:attachings) }

  describe '#icon' do
    context 'with audio' do
      let(:attachment) { create(:attachment, :audio) }

      it { expect(attachment.icon).to eql('fas fa-file-audio') }
    end

    context 'with image' do
      let(:attachment) { create(:attachment, :image) }

      it { expect(attachment.icon).to eql('fas fa-file-image') }
    end

    context 'with video' do
      let(:attachment) { create(:attachment, :video) }

      it { expect(attachment.icon).to eql('fas fa-file-video') }
    end

    context 'with other' do
      let(:attachment) { create(:attachment, :other) }

      it { expect(attachment.icon).to eql('fas fa-file') }
    end
  end
end
