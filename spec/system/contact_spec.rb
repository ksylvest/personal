require 'spec_helper'

RSpec.describe 'Search', type: :system do
  let(:verification) { instance_double('Recaptcha::API::Response') }

  context 'when re-captcha verification returns true' do
    it 'flashes that the message sent' do
      allow(Recaptcha).to receive(:verified?).and_return(true)

      visit contact_path

      fill_in('Name', with: 'Geogre Harrison')
      fill_in('Email', with: 'george.harrison@beatles.com')
      fill_in('Subject', with: 'Greetings!')
      fill_in('Message', with: 'How are things going?')
      click_button('Send')

      expect(page).to have_text('Your message is on the way.')
    end
  end

  context 'when re-captcha verification returns false' do
    it 'flashes that the message cannot be sent' do
      allow(Recaptcha).to receive(:verified?).and_return(false)

      visit contact_path

      fill_in('Name', with: 'Geogre Harrison')
      fill_in('Email', with: 'george.harrison@beatles.com')
      fill_in('Subject', with: 'Greetings!')
      fill_in('Message', with: 'How are things going?')
      click_button('Send')

      expect(page).to have_text('Your message is not being sent.')
    end
  end
end
