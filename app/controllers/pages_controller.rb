class PagesController < ApplicationController
  # GET /pages/:slug
  def show
    @page = Page.find!(slug: params.expect(:slug))
  end
end
