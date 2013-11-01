class AddColumnQuizProblemsCountToQuizzes < ActiveRecord::Migration
	def self.up
    	add_column :quizzes, :quiz_problems_count, :integer, :default => 0
    
    	Quiz.reset_column_information
    	Quiz.all.each do |q|
      		q.update_attribute :quiz_problems_count, q.quiz_problems.length
    	end
  	end

  def self.down
    remove_column :quizzes, :quiz_problems_count
  end
end
