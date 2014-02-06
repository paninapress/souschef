class ChangeSiteRecipe < ActiveRecord::Migration
  def change
    change_column :site_recipes, :preparation, :text
    change_column :site_recipes, :ingredients, :text
    change_column :site_recipes, :image, :text
    change_column :site_recipes, :source, :text
    change_column :site_recipes, :title, :text
  end
end
