class AddColumnActiveToClassroomProblemSets < ActiveRecord::Migration
  def change
    add_column :classroom_problem_sets, :active, :boolean
  end
end
