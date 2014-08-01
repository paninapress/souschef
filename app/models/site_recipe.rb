class SiteRecipe < ActiveRecord::Base
  paginates_per 12
  has_many :comments, as: :commentable
end
