class AddColumnPartialToQuizProblems < ActiveRecord::Migration
  def change
    add_column :quiz_problems, :partial, :boolean
  end
end
