class SiteController < ApplicationController
  def index
    @my_recipes = MyRecipe.order('created_at desc').page(params[:page]) if current_user
  end
end
