# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_commentable

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @commentable, notice: t('controllers.comment.notice_create', name: Comment.model_name.human)
    else
      redirect_to @commentable, alert: t('controllers.comment.alert_create_failed')
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.user == current_user
      @comment.destroy
      redirect_to @commentable, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
    else
      redirect_to @commentable, alert: t('controllers.comment.alert_no_permission')
    end
  end

  private

  def set_commentable
    if params[:book_id]
      @commentable = Book.find(params[:book_id])
    elsif params[:report_id]
      @commentable = Report.find(params[:report_id])
    else
      redirect_to root_path, alert: t('controllers.comments.alert_no_commentable')
    end
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
