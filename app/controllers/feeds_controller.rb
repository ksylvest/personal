class FeedsController < ApplicationController
  # GET /
  def show
    @posts = Post.all
  end
end
