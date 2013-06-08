class StaticPagesController < ApplicationController
  def home
    if user_signed_in?
      @posts = Post.paginate(page: params[:page]) #where(:parent_id, nil)
    end
  end

  def about
  end
end
