class PostsController < ApplicationController
  include Robots

  # GET /
  def index
    @posts = Post.optimized.ordered.query(params).page(params[:page])
    noindex if @posts.empty?

    fresh_when(last_modified: @posts.maximum(:updated_at) || @posts.maximum(:created_at))
  end

  # GET /posts/:segment/:slug
  def show
    @post = Post.optimized.find_by!(attributes)
    norobot unless @post.active?

    fresh_when(@post)
  end

private

  def attributes
    params.permit(:segment, :slug)
  end

end
