class ArchivesController < ApplicationController
  # GET /archive
  def show
    http_cache_forever(public: !params[:fresh]) do
      @posts = Post.ordered
    end
  end
end
