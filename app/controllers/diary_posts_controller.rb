class DiaryPostsController < ApplicationController
    before_action :authenticate_user!

    # app/controllers/diary_posts_controller.rb
   def index
    @posts = current_user.posts.where(kind: :diary, status: :published).order(updated_at: :desc)
   end

   def drafts
    @posts = current_user.posts.where(kind: :diary, status: :draft).order(updated_at: :desc)
   end

    def show
      @post = current_user.posts.find(params[:id])
    end

    def edit
      @post = current_user.posts.find(params[:id])
    end

    def update
      @post = current_user.posts.find(params[:id])
      if @post.update(post_params)
        redirect_to diary_post_path(@post), notice: "投稿を更新しました"
      else
        render :edit, status: :unprocessable_entity
      end
    end
  
    def new
      # 投稿する画面：自分しか見られない日記に投稿（下書き可）
      @post = current_user.posts.new(kind: :diary)
    end

    def create
      status = params[:save_as] == "下書き保存" ? :draft : :published
      @post = current_user.posts.new(post_params.merge(kind: :diary, status: status))
      if @post.save
        redirect_to status == :draft ? drafts_diary_posts_path : diary_posts_path
      else
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      @post = current_user.posts.find(params[:id])
      @post.destroy
      redirect_to diary_posts_path, notice: "投稿を削除しました"
    end
  
    private
  
    def post_params
      params.require(:post).permit(:location, :text, :image)
    end
  end