require 'spec_helper'

RSpec.describe Mailer, type: :mailer do
  describe '#contact' do
    subject(:mail) { Mailer.contact(contact) }

    let(:contact) { Contact.new(name: 'John', email: 'john@gmail.com', subject: 'Hello', message: 'How are you?') }

    it 'sends a message' do
      expect(mail.subject).to eq('Hello')
      expect(mail.from).to eq(['john@gmail.com'])
      expect(mail.body).to match('How are you?')
    end
  end
end
