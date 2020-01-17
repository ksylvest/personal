require 'spec_helper'

RSpec.describe Recaptcha do
  let(:fake_secret_key) { SecureRandom.alphanumeric }
  let(:response) { 'ABCDEF' }
  let(:remoteip) { '0.0.0.0' }

  describe '.verified?' do
    subject(:verified?) do
      allow(Recaptcha.config).to receive(:secret_key) { fake_secret_key }
      stub_request(:post, 'https://www.google.com/recaptcha/api/siteverify')
        .to_return(status: status, body: body)
      Recaptcha.verified?(response: response, remoteip: remoteip)
    end

    let(:status) { 200 }
    let(:body) do
      <<~JSON
        {
          "success": true,
          "score": 0.8,
          "action": "random",
          "hostname": "https://ksylvest.com"
        }
      JSON
    end

    it 'fetches a recaptcha verification' do
      expect(verified?).to be_truthy
    end
  end
end
