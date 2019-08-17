require 'spec_helper'

RSpec.describe 'Portfolio', type: :system do
  it 'links to every portfolio entry' do
    visit portfolio_path

    Portfolio.all.each do |portfolio|
      expect(page).to have_link(portfolio.name, href: portfolio.url)
    end
  end
end
