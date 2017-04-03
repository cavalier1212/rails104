class PostsController < ApplicationController
  before_action :authenticate_user!, :only => [:new, :create, :destroy, :edit, :update]
  before_action :samestuff, :only => [:edit, :update, :destroy]
  def new
    @group = Group.find(params[:group_id])
    @post = Post.new
  end

  def create
    @group = Group.find(params[:group_id])
    @post = Post.new(post_params)
    @post.group = @group
    @post.user = current_user

    if @post.save
      redirect_to group_path(@group)
    else
      render :new
    end
  end

  def edit

    if current_user != @post.user
      redirect_to group_path(@group), alert: "You have no permission!"
    end
  end

  def update

    @post.update(post_params)
    redirect_to account_posts_path, notice: "Edit Success!"
  end

  def destroy

    if @post.destroy
      flash[:alert] = "Post Delete"
    redirect_to account_posts_path

    end

  end

  private

  def samestuff
    @group = Group.find(params[:group_id])
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:content)
  end
end
