class SitemapsController < ApplicationController
  layout "sitemap"

  # GET /sitemap
  def show
    @posts = Post.all.reject(&:canonical_url)
    @pages = Page.all.reject(&:canonical_url)
  end
end
