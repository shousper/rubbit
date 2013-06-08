class PostsController < ApplicationController
  before_filter :authenticate_user!

  def show
    @post = Post.find(params[:id])
    @posts = @post.children

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  def new
    @post = current_user.posts.build

    if params[:post_id]
      @post.parent_id = params[:post_id]
      @parent = Post.find(@post.parent_id)
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def create
    @post = current_user.posts.build(body: params[:post][:body])
    @post.parent_id = params[:post_id] if params[:post_id] # Always use URL

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @post = current_user.posts.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def up
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.vote_up!(current_user)
        format.html { redirect_to @post, notice: 'Vote accepted!' }
        format.json { head :no_content }
        format.js { render 'update_counts' }
      else
        format.html { redirect_to @post, error: 'Unable to vote.' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def down
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.vote_down!(current_user)
        format.html { redirect_to @post, notice: 'Vote accepted!' }
        format.json { head :no_content }
        format.js { render 'update_counts' }
      else
        format.html { redirect_to @post, error: 'Unable to vote.' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

end
