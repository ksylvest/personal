class SitemapsController < ApplicationController
  layout 'sitemap'

  # GET /sitemap
  def show
    @posts = Post.ordered
    @pages = Page.ordered
  end
end
