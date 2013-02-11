class AddInfoForProblemStatusToProblemStats < ActiveRecord::Migration
	def change
		add_column :problem_set_stats, :points_right, 		:integer, null: false, default: 100 
		add_column :problem_set_stats, :points_wrong, 		:integer, null: false, default: 0
		add_column :problem_set_stats, :points_over_green, 	:integer, null: false, default: -500
		add_column :problem_set_stats, :modifier, 			:integer, null: false, default: 0

		# just need to default these to a time <= initialization
		add_column :problem_set_stats, :stop_green, :datetime, null: false, default: Time.now
		add_column :problem_set_instances, :stop_green, :datetime, null: false, default: Time.now
	end
end
