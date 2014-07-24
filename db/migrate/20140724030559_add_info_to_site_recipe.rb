class AddInfoToSiteRecipe < ActiveRecord::Migration
  def change
    add_column :site_recipes, :servings, :text
    add_column :site_recipes, :time, :text
    add_column :site_recipes, :calories, :text
    add_column :site_recipes, :fat, :text
    add_column :site_recipes, :saturated, :text
    add_column :site_recipes, :poly, :text
    add_column :site_recipes, :mono, :text
    add_column :site_recipes, :carb, :text
    add_column :site_recipes, :protein, :text
    add_column :site_recipes, :sodium, :text
    add_column :site_recipes, :fiber, :text
    add_column :site_recipes, :cholesterol, :text
  end
end
