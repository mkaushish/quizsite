class AddColumnLastAttemptedToProblemSetInstances < ActiveRecord::Migration
  def change
    add_column :problem_set_instances, :last_attempted, :timestamp
  end
end
