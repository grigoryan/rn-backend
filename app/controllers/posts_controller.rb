class PostsController < ApplicationController
  def index
    posts = Post.all
    render json: posts, include: :comments
  end

  def show
    post = Post.find(params[:id])
    render json: post, include: :comments
  end

  def create
    post = Post.new(post_params)
    post.account_id = params[:account_id]  # Adjust as per your user identification logic

    if post.save
      render json: post, status: :created
    else
      render json: post.errors, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:caption, :image)
  end
end
