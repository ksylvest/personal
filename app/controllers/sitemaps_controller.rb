class SitemapsController < ApplicationController
  layout 'sitemap'

  # GET /sitemap
  def show
    @posts = Post.canonical.ordered
    @pages = Page.canonical.ordered
  end
end
