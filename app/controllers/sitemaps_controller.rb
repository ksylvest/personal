class SitemapsController < ApplicationController
  layout 'sitemap'

  # GET /sitemap
  def show
    http_cache_forever(public: !params[:fresh]) do
      @posts = Post.ordered
      @pages = Page.ordered
    end
  end
end
