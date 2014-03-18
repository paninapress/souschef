class AddUserIdToMyRecipes < ActiveRecord::Migration
  def change
    add_column :my_recipes, :user_id, :integer
  end
end
