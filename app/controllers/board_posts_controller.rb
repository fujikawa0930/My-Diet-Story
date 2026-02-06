class BoardPostsController < ApplicationController
    before_action :authenticate_user!
  
    def index
      # 掲示板に公開されている投稿を新しい順に表示
      @posts = Post.where(status: :published).order(created_at: :desc)
    end
    
  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @comments = @post.comments.order(created_at: :desc)
  end
  
    def edit
      @post = Post.find(params[:id])
      return redirect_to board_posts_path, alert: "編集する権限がありません" unless @post.user_id == current_user.id
    end

    def update
      @post = Post.find(params[:id])
      if @post.user_id == current_user.id && @post.update(post_params)
        redirect_to board_post_path(@post), notice: "投稿を更新しました"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def new
      # 掲示板に投稿する画面
      @post = current_user.posts.new(kind: :board)
    end
  
    def create
      @post = current_user.posts.new(
        post_params.merge(kind: :board, status: :published)
      )
    
      def index
        @posts = Post.where(kind: :board, status: :published).includes(:user).order(created_at: :desc)
      end
    
if @post.save
        redirect_to board_posts_path
      else
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      @post = Post.find(params[:id])
      if @post.user_id == current_user.id
        @post.destroy
        redirect_to board_posts_path, notice: "投稿を削除しました"
      else
        redirect_to board_posts_path, alert: "削除する権限がありません"
      end
    end
    
    private
  
    def post_params
      params.require(:post).permit(:location, :text, :image)
    end
  end
  