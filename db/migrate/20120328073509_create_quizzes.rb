class CreateQuizzes < ActiveRecord::Migration
  	def change
    	create_table :quizzes do |t|
      		t.string	:name
      		t.binary 	:problemtypes
      		t.integer	:classroom_id
      		t.integer	:problem_set_id
      		t.string	:students
      		t.integer	:teacher_id
      		t.integer 	:quiz_problems_count, :default => 0
      		t.timestamps
    	end
  		add_index :quizzes, [:teacher_id, :name], :unique => true
  	end
end