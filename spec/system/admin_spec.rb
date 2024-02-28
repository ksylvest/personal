require 'spec_helper'

RSpec.describe 'Admin' do
  let(:user) { create(:user, role: :admin) }

  it 'lets a user authenticate with valid credentials' do
    visit admin_path
    within('form') do
      fill_in('Email', with: user.email)
      fill_in('Password', with: user.password)
      click_on('Login')
    end
    expect(page).to have_text('Account')
    expect(page).to have_text('Logout')
  end

  it 'prohibits a user authentication with invalid credentials' do
    visit admin_path
    within('form') do
      fill_in('Email', with: '')
      fill_in('Password', with: '')
      click_on('Login')
    end
    expect(page).to have_no_text('Account')
    expect(page).to have_no_text('Logout')
  end
end
