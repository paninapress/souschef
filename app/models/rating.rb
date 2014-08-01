class Rating < ActiveRecord::Base
  belongs_to :site_recipe
  belongs_to :my_recipe
  belongs_to :user

end
