class AddProfilePicToComment < ActiveRecord::Migration
  def change
    add_column :comments, :profile, :string
  end
end
