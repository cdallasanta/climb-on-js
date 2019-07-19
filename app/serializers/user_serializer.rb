class UserSerializer < ApplicationSerializer
  attributes :id, :fullname
  has_many :comments
end
