class DiaryPostsController < ApplicationController
    before_action :authenticate_user!
  
    def index
      # 自分の日記（公開）
      @posts = current_user.posts.diary.published.order(created_at: :desc)
    end
  
    def drafts
      # 自分の日記（下書き）
      @posts = current_user.posts.diary.draft.order(updated_at: :desc)
    end
  
    def new
      # 日記を書く画面
      @post = current_user.posts.new(kind: :diary)
    end
  
    def create
      @post = current_user.posts.new(post_params.merge(kind: :diary))
      if @post.save
        redirect_to diary_posts_path
      else
        render :new, status: :unprocessable_entity
      end
    end
  
    private
  
    def post_params
      params.require(:post).permit(:text, :image, :status)
    end
  end
  