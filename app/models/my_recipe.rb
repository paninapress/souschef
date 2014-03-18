class MyRecipe < ActiveRecord::Base
  mount_uploader :photo, PhotoUploader
  belongs_to :user

  paginates_per 25
  validates :title, presence: true
  validates :description, presence: true


end
