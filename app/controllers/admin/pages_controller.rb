class Admin::PagesController < AdminController
  before_action :admin!

  # GET /admin/pages
  def index
    @pages = user.pages.ordered.page(params[:page]).per(params[:per])
  end

  # GET /admin/pages/new
  def new
    @page = user.pages.new
  end

  # GET /admin/pages/:id/edit
  def edit
    @page = user.pages.find(params[:id])
  end

  # POST /admin/pages/:id
  def create
    @page = user.pages.new(attributes)

    if @page.save
      redirect_to admin_pages_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH /admin/pages/:id
  def update
    @page = user.pages.find(params[:id])

    if @page.update(attributes)
      redirect_to admin_pages_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /admin/pages/:id
  def destroy
    @page = user.pages.find(params[:id])
    @page.destroy

    redirect_to admin_pages_path
  end

private

  def attributes
    params.require(:page).permit(:title, :body, :summary, :taggables, :canonical_url)
  end
end
