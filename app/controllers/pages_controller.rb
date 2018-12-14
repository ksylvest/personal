class PagesController < ApplicationController
  include Robots

  # GET /pages/:slug
  def show
    @page = Page.find_by!(attributes)
    norobot unless @page.active?

    fresh_when(@page)
  end

private

  def attributes
    params.permit(:slug)
  end

end
