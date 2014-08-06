class MyRecipe < ActiveRecord::Base
	before_save :set_recipe
  mount_uploader :photo, PhotoUploader
  belongs_to :user
  has_many :comments, as: :commentable
  has_many :ratings
  paginates_per 25
  validates :title, presence: true
  validates :ingredients, presence: true
  validates :preparation, presence: true

 def average_rating
  if ratings.size == 0
    ratings.sum(:score)
  else
  ratings.sum(:score) / ratings.size
end
end


def set_recipe
  self.sodium = "N/A" if self.sodium.blank?
  self.fat = "N/A" if self.fat.blank?
  self.calories = "N/A" if self.calories.blank?
  self.protein = "N/A" if self.protein.blank?
  self.time = "N/A" if self.time.blank?
  self.servings = "N/A" if self.servings.blank?
  self.mono = "N/A" if self.mono.blank?
  self.poly = "N/A" if self.poly.blank?
  self.fiber = "N/A" if self.fiber.blank?
  self.carb = "N/A" if self.carb.blank?
  self.cholesterol = "N/A" if self.cholesterol.blank?
  self.saturated = "N/A" if self.saturated.blank?
end


end
