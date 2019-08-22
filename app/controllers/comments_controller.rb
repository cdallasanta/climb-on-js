class CommentsController < ApplicationController
  def index
    @comments = current_site.recent_comments
  end
end