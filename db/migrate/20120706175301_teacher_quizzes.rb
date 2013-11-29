class TeacherQuizzes < ActiveRecord::Migration
  	def change
    	create_table :hw_assignments do |t|
      		t.integer :classroom_id
      		t.integer :homework_id
    	end
  	end
end