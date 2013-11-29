class CreateTopics < ActiveRecord::Migration
  	def change
    	create_table :topics do |t|
			t.string :title
			t.integer :user_id
			t.integer :classroom_id
			t.integer :comments_count, :default => 0
	
			t.timestamps
    	end
  	end
end
