class User < ApplicationRecord
  include Mongoid::Document
  include Mongoid::Timestamps

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :timeoutable #, :omniauthable , omniauth_providers: [:linkedin, :google, :facebook]

  field :first_name, type: String
  field :last_name, type: String
  field :access_token,    type: String, default: ""

  # Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  has_many :posts
  has_many :comments

  validates :first_name, :email, presence: true

  def self.authorize! params
    User.find_by(id: params[:user_id], access_token: params[:access_token])
  end
end
