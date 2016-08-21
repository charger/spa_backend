class Api::V1::PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]

  def index
    filter = PostFilter.new(filter_params)

    render json: filter.posts
  end

  def show
    render json: @post
  end

  def create
    @post = Post.new(post_params)

    if @post.save
      render json: @post, status: :created, location: api_post_url(@post)
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :body, :image)
    end

    def filter_params
      {
        filter: params[:filter],
        order: params[:order],
        order_direction: params[:order_direction],
        page: params[:page]
      }
    end
end
