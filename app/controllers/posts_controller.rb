class PostsController < ApplicationController
  # GET /
  def index
    @page = params[:page]
    @tag = params[:tag]
    @posts = Kaminari.paginate_array(Post.tagged(tag: @tag)).page(@page)
    redirect_to root_path if @posts.none? && (@page || @tag)
  end

  # GET /posts/:slug
  # GET /posts/:segment/:slug
  def show
    @post = Post.find!(slug: params.expect(:slug))
  end
end
