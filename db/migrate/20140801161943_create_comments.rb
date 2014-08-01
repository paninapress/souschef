class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content
      t.integer :commentable_id
      t.string :commentable_type
      t.string :username
      t.belongs_to :commentable, polymorphic: true
      t.timestamps
    end
  end
end
