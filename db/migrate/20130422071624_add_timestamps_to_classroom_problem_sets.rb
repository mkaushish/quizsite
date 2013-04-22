class AddTimestampsToClassroomProblemSets < ActiveRecord::Migration
  def change
    add_column :classroom_problem_sets, :created_at, :datetime
    add_column :classroom_problem_sets, :updated_at, :datetime
  end
end
