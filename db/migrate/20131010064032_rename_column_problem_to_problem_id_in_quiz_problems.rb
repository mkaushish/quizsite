class RenameColumnProblemToProblemIdInQuizProblems < ActiveRecord::Migration
  def up
  	rename_column :quiz_problems, :problem, :problem_id
  end

  def down
  	rename_column :quiz_problems, :problem_id, :problem
  end
end
