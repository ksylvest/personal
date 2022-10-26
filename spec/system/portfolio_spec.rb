require 'spec_helper'

RSpec.describe 'Portfolio' do
  it 'links to every portfolio entry' do
    visit portfolio_path

    Portfolio.all.each do |portfolio|
      if portfolio.url
        expect(page).to have_link(portfolio.name, href: portfolio.url)
      else
        expect(page).to have_text(portfolio.name)
      end
    end
  end
end
