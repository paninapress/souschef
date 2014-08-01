class SiteRecipe < ActiveRecord::Base
  paginates_per 12
  has_many :comments, as: :commentable
  has_many :ratings

  def average_rating
  ratings.sum(:score) / ratings.size
end

end
