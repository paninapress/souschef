class AddInfoToMyRecipes < ActiveRecord::Migration
  def change
    add_column :my_recipes, :servings, :text
    add_column :my_recipes, :time, :text
    add_column :my_recipes, :calories, :text
    add_column :my_recipes, :fat, :text
    add_column :my_recipes, :saturated, :text
    add_column :my_recipes, :poly, :text
    add_column :my_recipes, :mono, :text
    add_column :my_recipes, :carb, :text
    add_column :my_recipes, :protein, :text
    add_column :my_recipes, :sodium, :text
    add_column :my_recipes, :fiber, :text
    add_column :my_recipes, :cholesterol, :text
  end
end
