class LinkProblemSetStatsToProblemStats < ActiveRecord::Migration
  def change
    add_column :problem_set_stats, :problem_stat_id, :integer
  end
end
