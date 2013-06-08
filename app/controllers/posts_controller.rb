class PostsController < ApplicationController
  before_filter :authenticate_user!, except: [:show, :named]

  def named
    @posts = Post.root_named_feed.paginate(page: params[:page])
    render 'static_pages/home'
  end

  def show
    @post = Post.try_find(params[:id])
    @posts = @post.children

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  def new
    @post = current_user.posts.build
    @nameable = true

    if params[:post_id]
      @parent = Post.try_find(params[:post_id])
      @post.parent_id = @parent.id

      @has_root_path = @parent.path && !@parent.path.empty?
      @nameable = @has_root_path
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  def create
    @post = current_user.posts.build(params[:post])

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

  def edit
    @post = Post.find(params[:id])
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
    @post = Post.try_find(params[:id])

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
    @post = Post.try_find(params[:id])

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
