class AddColumnProblemSetNameToProblemSetInstances < ActiveRecord::Migration
  	def change
    	add_column :problem_set_instances, :problem_set_name, :string
    	# ProblemSetInstance.all.each do |problem_set_instance|
    	# 	problem_set_instance.problem_set_name = problem_set_instance.name
    	# 	p "problem_set_instance with id #{problem_set_instance.id.to_s} updated with problem_set_name #{problem_set_instance.problem_set_name}" if problem_set_instance.save!
    	# end
  	end
end
