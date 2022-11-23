class PostsController < ApplicationController
  include Robots

  # GET /
  def index
    @posts = Post.optimized.ordered.query(params).page(params[:page])
    redirect_to root_path if @posts.none? && params[:page]
  end

  # GET /posts/:segment/:slug
  def show
    @post = Post.optimized.find_by!(attributes)
    norobot unless @post.active?
  end

private

  def attributes
    params.permit(:segment, :slug)
  end
end
