class PostsController < ApplicationController
  include Robots

  # GET /
  def index
    @page = params[:page]
    @tag = params[:tag]
    @posts = Post.optimized.ordered.tagged(@tag).page(@page)
    redirect_to root_path if @posts.none? && (@page || @tag)
  end

  # GET /posts/:slug
  # GET /posts/:segment/:slug
  def show
    @post = Post.optimized.find_by!(slug: params[:slug])
    norobot unless @post.active?
  end
end
