class SearchesController < ApplicationController

  # GET /search
  def show
    @search = Search.new(params[:search])
    @pages = @search.pages
    @posts = @search.posts
  end

end
