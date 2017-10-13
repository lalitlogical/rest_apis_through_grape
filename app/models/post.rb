class Post < ApplicationRecord
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :content, type: String, default: ""
  field :views, type: Integer, default: 0

  belongs_to :user
  has_many :comments

  # validates :title, uniqueness: { case_sensitive: false }
  validates :title, :content, presence: true
end
