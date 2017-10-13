class CommentSerializer < ActiveModel::Serializer
  attributes :id, :post_id, :message, :like
end
