class AlterIndexOfQuizProblems < ActiveRecord::Migration
  def up
  	remove_index :quiz_problems, :column => [:quiz_id, :problem_type_id]
  	add_index :quiz_problems, [:quiz_id, :problem_type_id]
  end

  def down
  	remove_index :quiz_problems, [:quiz_id, :problem_type_id]
  	add_index :quiz_problems, [:quiz_id, :problem_type_id], :unique => true
  end
end
