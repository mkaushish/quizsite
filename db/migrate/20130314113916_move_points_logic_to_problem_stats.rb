class MovePointsLogicToProblemStats < ActiveRecord::Migration
  def up
    remove_column :problem_set_stats, :points, :points_right, :points_wrong, :points_over_green, :stop_green

    add_column :problem_stats, :points, :integer, default: 0, null: false
    add_column :problem_stats, :points_wrong, :integer, default: 0, null: false
    add_column :problem_stats, :points_right, :integer, default: 100, null: false
    add_column :problem_stats, :stop_green,   :datetime, default: Time.now, null: false
  end

  def down
    remove_column :problem_stats, :points, :points_right, :points_wrong, :stop_green

    add_column :problem_set_stats, :points, :integer, default: 0, null: false
    add_column :problem_set_stats, :points_over_green, :integer, default: -500, null: false
    add_column :problem_set_stats, :points_wrong, :integer, default: 0, null: false
    add_column :problem_set_stats, :points_right, :integer, default: 100, null: false
    add_column :problem_set_stats, :stop_green,   :datetime, default: Time.now, null: false
  end
end
