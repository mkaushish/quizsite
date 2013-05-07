class FixUpQuizInstances < ActiveRecord::Migration
  def up
    remove_column :quiz_instances, :s_problem_order
    remove_column :quiz_instances, :problem_id
    remove_column :quiz_instances, :num_attempts
    add_column :quiz_instances, :ended_at, :datetime
    add_column :quiz_instances, :complete, :boolean, :default => nil
  end

  def down
    add_column :quiz_instances, :s_problem_order, :string
    add_column :quiz_instances, :problem_id, :integer, :default => -1
    add_column :quiz_instances, :num_attempts, :integer, :default => 0
    remove_column :quiz_instances, :ended_at
    remove_column :quiz_instances, :complete
  end
end
