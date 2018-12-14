class SitemapController < ApplicationController
  layout 'sitemap'

  def index
    @posts = Post.ordered
    @pages = Page.ordered
  end

end
