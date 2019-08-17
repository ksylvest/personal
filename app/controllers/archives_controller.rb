class ArchivesController < ApplicationController
  # GET /archive
  def show
    @posts = Post.ordered
  end
end
