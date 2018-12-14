require 'spec_helper'

feature 'Authentication' do
  scenario 'with valid email and password' do
    user = Fabricate(:user, role: 'admin')
    authenticate(user)

    expect(page).to have_content('Account')
    expect(page).to have_content('Logout')
  end

  scenario 'with an invalid email and password' do
    user = Fabricate(:user, role: 'admin')
    allow(user).to receive(:password) { 'hacker' }
    authenticate(user)

    expect(page).to_not have_content('Account')
    expect(page).to_not have_content('Logout')
  end

  scenario 'without authenticating' do
    visit edit_admin_user_path

    expect(page).to_not have_content('Account')
    expect(page).to_not have_content('Logout')
  end
end
