class Comment < ApplicationRecord
  include Mongoid::Document
  include Mongoid::Timestamps

  field :message, type: String, default: ""
  field :like, type: Integer, default: 0

  belongs_to :user
  belongs_to :post

  # validates :title, uniqueness: { case_sensitive: false }
  validates :message, presence: true
end
