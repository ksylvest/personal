class SearchesController < ApplicationController
  # GET /search?query=:query
  def show
    @search = Search.new(params[:query])
    @pages = @search.pages
    @posts = @search.posts
  end
end
