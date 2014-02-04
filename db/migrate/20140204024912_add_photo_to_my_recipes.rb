class AddPhotoToMyRecipes < ActiveRecord::Migration
  def change
    add_column :my_recipes, :photo, :string
  end
end
