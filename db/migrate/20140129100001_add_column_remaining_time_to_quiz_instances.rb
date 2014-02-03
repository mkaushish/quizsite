class AddColumnRemainingTimeToQuizInstances < ActiveRecord::Migration
  def change
    add_column :quiz_instances, :remaining_time, :integer
  end
end
