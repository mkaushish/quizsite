class AddColumnsInProblemSetInstance < ActiveRecord::Migration
  def change
  	add_column :problem_set_instances, :num_blue, :integer
  	add_column :problem_set_instances, :num_green, :integer
  	add_column :problem_set_instances, :num_red, :integer
  end
end
