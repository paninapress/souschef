class MyRecipe < ActiveRecord::Base
  mount_uploader :photo, PhotoUploader
  belongs_to :user
  has_many :comments, as: :commentable
  paginates_per 25
  validates :title, presence: true
  validates :description, presence: true


end
