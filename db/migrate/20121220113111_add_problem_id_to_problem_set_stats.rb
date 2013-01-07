class AddProblemIdToProblemSetStats < ActiveRecord::Migration
  def change
    add_column :problem_set_stats, :current_problem_id, :integer
  end
end
