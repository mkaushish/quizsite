class AlterColumnCountToQuizProblems < ActiveRecord::Migration
  def up
  	change_column :quiz_problems, :count, :integer, :default => 1
  end

  def down
  	change_column :quiz_problems, :count, :integer, :default => 2
  end
end
