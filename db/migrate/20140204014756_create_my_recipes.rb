class CreateMyRecipes < ActiveRecord::Migration
  def change
    create_table :my_recipes do |t|
      t.string :title
      t.string :description
      t.string :speechlink

      t.timestamps
    end
  end
end
