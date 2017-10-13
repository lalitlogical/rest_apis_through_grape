class PostSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :title, :content, :views

  has_many :comments
end
