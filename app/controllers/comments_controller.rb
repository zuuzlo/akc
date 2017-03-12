class CommentsController < ApplicationController
  before_action :find_commentable
  def new
    @comment = Comment.new
  end

  def create
    @comment = @commentable.comments.new comment_params

    if @comment.save
      flash[:success] = 'Your comment was successfully posted!'
      redirect_to :back
    else
      flash[:danger] = "Your comment wasn't posted!"
      redirect_to :back
    end

  end

  private

  def comment_params

    params.require(:comment).permit(:comment, :email, :website)
  end

  def find_commentable
    @commentable = Comment.find_by_id(params[:comment_id]) if params[:comment_id]
    @commentable = Coupon.friendly.find(params[:coupon_id]) if params[:coupon_id]
  end
end
