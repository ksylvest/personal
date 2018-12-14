require 'spec_helper'

feature 'Portfolios' do

  before(:each) do
    @page = Fabricate(:page)
  end

  scenario 'visiting a page' do
    visit portfolio_path

    Portfolio.all.each do |portfolio|
      expect(page).to have_link(portfolio.name, href: portfolio.url)
    end
  end

end
