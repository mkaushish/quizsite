class AddColumnProblemSetProblemsCountToProblemSets < ActiveRecord::Migration
  	def self.up
  		add_column :problem_sets, :problem_set_problems_count, :integer, default: 0
	    add_column :problem_sets, :problem_set_instances_count, :integer, default: 0
	  	ProblemSet.reset_column_information
	  	ProblemSet.find(:all).each do |problem_set|
	    	ProblemSet.update_counters problem_set.id, :problem_set_problems_count => problem_set.problem_set_problems.count, :problem_set_instances_count => problem_set.problem_set_instances.count
	  	end
  	end

  	def self.down
  		remove_column :problem_sets, :problem_set_problems_count
      remove_column :problem_sets, :problem_set_instances_count
  	end
end
