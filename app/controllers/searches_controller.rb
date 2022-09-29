class SearchesController < ApplicationController
  # GET /search?query=:query
  def show
    http_cache_forever(public: !params[:fresh]) do
      @search = Search.new(params[:query])
      @pages = @search.pages
      @posts = @search.posts
    end
  end
end
