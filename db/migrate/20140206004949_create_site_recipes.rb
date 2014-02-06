class CreateSiteRecipes < ActiveRecord::Migration
  def change
    create_table :site_recipes do |t|
      t.string :title
      t.text :ingredients
      t.text :preparation
      t.text :image
      t.string :source

      t.timestamps
    end
  end
end
