require 'spec_helper'

describe Mailer do
  describe '#contact' do
    let(:contact) { Contact.new(name: 'John', email: 'john@gmail.com', subject: 'Hello', message: 'How are you?') }
    let(:mail) { Mailer.contact(contact) }

    it 'sends a message' do
      expect(mail.subject).to eq('Hello')
      expect(mail.from).to eq(['john@gmail.com'])
      expect(mail.body).to match('How are you?')
    end
  end
end
