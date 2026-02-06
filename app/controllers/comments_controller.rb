class CommentsController < ApplicationController
    def create
        post = Post.find(params[:board_post_id])
        @comment = current_user.comments.new(comment_params)
        @comment.post = post
        if @comment.save
            redirect_to board_post_path(post)
        else
            @post = post
            @comments = @post.comments.order(created_at: :desc)
            render 'board_posts/show', status: :unprocessable_entity
        end
    end
    
    def destroy
        Comment.find_by(id: params[:id], post_id: params[:board_post_id]).destroy
        redirect_to board_post_path(params[:board_post_id])
    end
    
    private
    def comment_params
        params.require(:comment).permit(:comment)
    end
end
