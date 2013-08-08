class AddColumnProblemIdToQuizStats < ActiveRecord::Migration
  def self.up
  	add_column :quiz_stats, :problem_id, :integer
  end

  def self.down
  	remove_column :quiz_stats, :problem_id
  end
end
