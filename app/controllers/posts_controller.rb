class PostsController < ApplicationController
  include Robots

  # GET /
  def index
    @posts = Post.optimized.ordered.query(params).page(params[:page])
    redirect_to root_path if @posts.none? && params[:page]
  end

  # GET /posts/:slug
  # GET /posts/:segment/:slug
  def show
    @post = Post.optimized.find_by!(slug: params[:slug])
    norobot unless @post.active?
  end
end
