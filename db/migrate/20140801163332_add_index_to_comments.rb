class AddIndexToComments < ActiveRecord::Migration
  def change
  	 add_index :comments, ["commentable_id", "commentable_type", 
      	"username"], :name => "my_index"
  end
end
