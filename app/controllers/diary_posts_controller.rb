class DiaryPostsController < ApplicationController
    before_action :authenticate_user!
  
    def index
      # kind カラムが無い環境でも動くように、status のみで絞り込む
      @posts = current_user.posts.where(status: :published).order(created_at: :desc)
    end
    
  
    def drafts
      # 自分の日記（下書き）※ kind では絞らず、status のみ
      @posts = current_user.posts.where(status: :draft).order(updated_at: :desc)
    end
  
    def new
      # 日記を書く画面
      @post = current_user.posts.new(kind: :diary)
    end
  
    def create
      status = params[:save_as] == "draft" ? :draft : :published
      @post = current_user.posts.new(post_params.merge(kind: :diary, status: status))
      if @post.save
        redirect_to status == :draft ? drafts_diary_posts_path : diary_posts_path
      else
        render :new, status: :unprocessable_entity
      end
    end
  
    private
  
    def post_params
      params.require(:post).permit(:text, :image)
    end
  end