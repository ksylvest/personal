class FeedsController < ApplicationController
  # GET /
  def show
    http_cache_forever(public: !params[:fresh]) do
      @posts = Post.all
    end
  end
end
