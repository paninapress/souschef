class User < ActiveRecord::Base
  has_many :my_recipes
  has_many :ratings
  has_many :comments, as: :commentable
   mount_uploader :avatar, AvatarUploader
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable
end
