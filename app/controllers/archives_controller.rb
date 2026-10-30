class ArchivesController < ApplicationController
  # GET /archive
  def show
    @posts = Post.all
  end
end
