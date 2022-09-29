class PostsController < ApplicationController
  include Robots

  # GET /
  def index
    http_cache_forever(public: !params[:fresh]) do
      @posts = Post.optimized.ordered.query(params).page(params[:page])
      redirect_to root_path if @posts.none? && params[:page]
    end
  end

  # GET /posts/:segment/:slug
  def show
    http_cache_forever(public: !params[:fresh]) do
      @post = Post.optimized.find_by!(attributes)
      norobot unless @post.active?
    end
  end

private

  def attributes
    params.permit(:segment, :slug)
  end
end
