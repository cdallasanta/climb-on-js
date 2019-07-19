class CommentSerializer < ApplicationSerializer
  attributes :content, :user
  belongs_to :user
  belongs_to :commentable, polymorphic: true
end