class PagesController < ApplicationController
  include Robots

  # GET /pages/:slug
  def show
    http_cache_forever(public: !params[:fresh]) do
      @page = Page.find_by!(attributes)
      norobot unless @page.active?
    end
  end

private

  def attributes
    params.permit(:slug)
  end
end
