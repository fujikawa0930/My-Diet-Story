class BoardPostsController < ApplicationController
    before_action :authenticate_user!
  
    def index
      # 掲示板（みんなの公開投稿）
      @posts = Post.board.published.order(created_at: :desc)
    end
  
    def new
      # 掲示板に投稿する画面
      @post = current_user.posts.new(kind: :board)
    end
  
    def create
      @post = current_user.posts.new(
        post_params.merge(kind: :board, status: :published)
      )
  
      if @post.save
        redirect_to board_posts_path
      else
        render :new, status: :unprocessable_entity
      end
    end
  
    private
  
    def post_params
      params.require(:post).permit(:text, :image)
    end
  end
  