class RenameColumnProblemSetNameToNameToProblemSetInstances < ActiveRecord::Migration
  def up
  	rename_column :problem_set_instances, :problem_set_name, :name
  end

  def down
  	rename_column :problem_set_instances, :name, :problem_set_name
  end
end
