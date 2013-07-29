class AddProblemColumnToQuizProblems < ActiveRecord::Migration
  def change
    add_column :quiz_problems, :problem, :integer
  end
end
