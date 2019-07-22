class CommentSerializer < ActiveModel::Serializer
  attributes :content, :user
  belongs_to :user
  belongs_to :commentable, polymorphic: true
end