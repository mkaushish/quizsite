class AddColumnLastVisitedAtToQuizInstances < ActiveRecord::Migration
  def change
    add_column :quiz_instances, :last_visited_at, :datetime
  end
end
