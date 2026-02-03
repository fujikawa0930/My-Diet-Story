class PostsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]

  def new
    @post = Post.new
    @from_board = params[:from] == "board"
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    from_board = params[:from] == "board"
    @post.status = from_board ? :published : :draft
    if @post.save
      if from_board
        redirect_to posts_path, notice: "掲示板に投稿しました。"
      else
        redirect_to my_posts_posts_path, notice: "投稿しました。投稿一覧で確認できます。"
      end
    else
      @from_board = from_board
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @posts = Post.published.page(params[:page]).reverse_order
    @posts = @posts.where('location LIKE ?', "%#{params[:search]}%") if params[:search].present?
  end

  def my_posts
    @posts = current_user.posts.draft.page(params[:page]).reverse_order
    @posts = @posts.where('location LIKE ?', "%#{params[:search]}%") if params[:search].present?
    @my_posts = true
    render :index
  end

  def show
    @post = Post.find(params[:id])
    if @post.draft? && current_user != @post.user
      redirect_to posts_path, alert: "この投稿は閲覧できません。"
      return
    end
    @comment = Comment.new
    @comments = @post.comments.page(params[:page]).per(7).reverse_order
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post.id)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to posts_path
  end

  def confirm
    @posts = current_user.posts.draft.page(params[:page]).reverse_order
  end

  private
  def post_params
    params.require(:post).permit(:user_id, :location, :text, :image, :status)
  end

end
