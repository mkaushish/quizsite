class AddProblemSetInstanceIdToQuizInstances < ActiveRecord::Migration
  def change
    add_column :quiz_instances, :problem_set_instance_id, :integer
  end
end
