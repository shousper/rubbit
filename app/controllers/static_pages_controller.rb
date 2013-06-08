class StaticPagesController < ApplicationController
  def home
    if user_signed_in?
      @posts = Post.root_feed.paginate(page: params[:page])
      @named = Post.root_named_feed.limit(10)
    end
  end

  def about
  end
end
