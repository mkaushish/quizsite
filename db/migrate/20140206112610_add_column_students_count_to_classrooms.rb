class AddColumnStudentsCountToClassrooms < ActiveRecord::Migration
  	def self.up
    	add_column :classrooms, :students_count, :integer
    	add_column :classrooms, :problem_sets_count, :integer
    	add_column :classrooms, :quizzes_count, :integer
    	Classroom.reset_column_information
	  	Classroom.find(:all).each do |classroom|
	    	Classroom.update_counters classroom.id, :students_count => classroom.classroom_assignments.count, :problem_sets_count => classroom.classroom_problem_sets.count, :quizzes_count => classroom.classroom_quizzes.count
	  	end
  	end

  	def self.down
  		remove_column :classrooms, :students_count
  		remove_column :classrooms, :problem_sets_count
  		remove_column :classrooms, :quizzes_count
  	end
end
