class AddColumnProblemCategoryToQuizProblems < ActiveRecord::Migration
  def change
    add_column :quiz_problems, :problem_category, :string
  end
end
