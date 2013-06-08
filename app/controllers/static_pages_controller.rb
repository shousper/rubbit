class StaticPagesController < ApplicationController
  def home
    if user_signed_in?
      @posts = Post.where('parent_id IS NULL')
        .order('votes DESC, updated_at DESC')
        .paginate(page: params[:page])
    end
  end

  def about
  end
end
