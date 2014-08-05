class AddRecipeInfoToMyRecipes < ActiveRecord::Migration
  def change
    add_column :my_recipes, :ingredients, :text
    add_column :my_recipes, :preparation, :text
  end
end
