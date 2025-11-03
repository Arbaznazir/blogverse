class PostsController < ApplicationController

  before_action :require_login!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_post,       only: [:show, :edit, :update, :destroy]
  before_action :require_owner!, only: [:edit, :update, :destroy]

  def index
    # Views soon. For now, just fetch newest first.
    @posts = Post.includes(:user).order(created_at: :desc)
  end

  def show
  end

  def new
    # Build through the association so user_id is correct
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to @post, notice: "Posted!"
    else
      flash.now[:alert] = "Please fix the errors below."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: "Updated."
    else
      flash.now[:alert] = "Please fix the errors below."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "Deleted."
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def require_owner!
    return if owner?(@post)
    redirect_to @post, alert: "Not yours to change."
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end
end

