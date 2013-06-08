class StaticPagesController < ApplicationController
  def home
    @posts = Post.root_feed.paginate(page: params[:page])
    @named = Post.root_named_feed.limit(10)
  end

  def about
  end
end
