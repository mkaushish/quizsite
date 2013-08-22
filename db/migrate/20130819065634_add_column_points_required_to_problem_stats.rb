class AddColumnPointsRequiredToProblemStats < ActiveRecord::Migration
  def change
    add_column :problem_stats, :points_required, :integer, :default => 500
  end
end
