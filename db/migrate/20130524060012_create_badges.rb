class CreateBadges < ActiveRecord::Migration
  	def self.up
    	create_table :badges do |t|
    		t.integer 	:student_id
    		t.string	:name
    		t.string	:badge_key
    		t.string	:image
    		t.integer	:level
    		t.integer	:answer_id
    		t.integer	:comment_id
    		t.integer	:teacher_id
    		
       		t.timestamps
    	end
  	end
end
