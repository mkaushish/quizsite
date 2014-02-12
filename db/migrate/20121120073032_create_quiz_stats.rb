class CreateQuizStats < ActiveRecord::Migration
  	def change
    	create_table :quiz_stats do |t|
      		t.references 	:quiz_instance
      		t.references 	:problem_type
      		t.integer    	:remaining, default: 0
      		t.integer    	:total
      		t.integer		  :problem_id
          t.timestamps
    	end
  	end
end
