class CommentsController < ApplicationController
  def index
    @comments = current_site.recent_comments
  end

  def show
    @comment = Comment.find(params[:id])
    render json: @comment
  end
end
