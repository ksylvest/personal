class Admin::PostsController < AdminController
  before_action :admin!

  # GET /admin/posts
  def index
    @posts = user.posts.ordered.page(params[:page]).per(params[:per])
  end

  # GET /admin/posts/new
  def new
    @post = user.posts.new
  end

  # GET /admin/posts/:id/edit
  def edit
    @post = user.posts.find(params[:id])
  end

  # POST /admin/posts/:id
  def create
    @post = user.posts.new(attributes)

    if @post.save
      redirect_to admin_posts_path
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH /admin/posts/:id
  def update
    @post = user.posts.find(params[:id])

    if @post.update(attributes)
      redirect_to admin_posts_path
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /admin/posts/:id
  def destroy
    @page = user.posts.find(params[:id])
    @page.destroy

    redirect_to admin_posts_path
  end

private

  def attributes
    params.require(:post).permit(:title, :body, :summary, :taggables, :canonical_url)
  end
end
