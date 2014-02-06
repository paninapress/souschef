class CreateSiteRecipes < ActiveRecord::Migration
  def change
    create_table :site_recipes do |t|
      t.string :title
      t.string :ingredients
      t.string :preparation
      t.string :image
      t.string :source

      t.timestamps
    end
  end
end
