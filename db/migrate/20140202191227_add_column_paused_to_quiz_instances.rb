class AddColumnPausedToQuizInstances < ActiveRecord::Migration
  def change
    add_column :quiz_instances, :paused, :boolean
  end
end
