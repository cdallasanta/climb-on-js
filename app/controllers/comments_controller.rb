class CommentsController < ApplicationController
  def index
    @comments = current_site.recent_comments
  end
# TODO clean all this up
  def show
    @comment = Comment.find(params[:id])
    render json: @comment, message: "test"
  end
end
