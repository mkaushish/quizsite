class CreateComments < ActiveRecord::Migration
  	def change
    	create_table :comments do |t|
			t.text	:content

			t.integer :user_id
			t.integer :answer_id
			t.integer :classroom_id
			t.integer	:reply_comment_id
			t.integer	:topic_id
			
			t.timestamps
    	end
  	end
end
