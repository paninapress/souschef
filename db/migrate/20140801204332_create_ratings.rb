class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.references :site_recipe, index: true
      t.references :my_recipe, index: true
      t.references :user, index: true
      t.integer :score
      t.string :default

      t.timestamps
    end
  end
end
