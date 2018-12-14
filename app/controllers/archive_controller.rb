class ArchiveController < ApplicationController

  def index
    @posts = Post.ordered

    fresh_when(last_modified: @posts.maximum(:updated_at) || @posts.maximum(:created_at))
  end

end
