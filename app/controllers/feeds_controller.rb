class FeedsController < ApplicationController
  # GET /
  def show
    @posts = Post.order(id: :desc)
  end
end
