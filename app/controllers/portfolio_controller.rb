class PortfolioController < ApplicationController
  def index
    @portfolio = Portfolio.with_attached_images.order(:id)
  end
end
