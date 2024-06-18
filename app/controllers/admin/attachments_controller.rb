class Admin::AttachmentsController < AdminController
  before_action :admin!

  # GET /admin/attachments
  def index
    @attachments = Attachment.page(params[:page])
  end

  # GET /admin/attachments/new
  def new
    @attachment = Attachment.new
  end

  # GET /admin/posts/:id/edit
  def edit
    @attachment = Attachment.find(params[:id])
  end

  # POST /admin/attachments/attachment
  def create
    @attachment = Attachment.new(attributes)

    if @attachment.save
      redirect_to admin_attachments_path
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH /admin/attachments/:id
  def update
    @attachment = Attachment.find(params[:id])
    @attachment.attributes = attributes
    @attachment.save

    if @attachment.save
      redirect_to admin_attachments_path
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /admin/attachments/:id
  def destroy
    @attachment = Attachment.find(params[:id])
    @attachment.destroy!

    redirect_to admin_attachments_path
  end

private

  def attributes
    params.require(:attachment).permit(:name, :file)
  end
end
