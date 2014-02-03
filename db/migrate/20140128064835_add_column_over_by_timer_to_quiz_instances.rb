class AddColumnOverByTimerToQuizInstances < ActiveRecord::Migration
	def change
		add_column :quiz_instances, :over_by_timer, :boolean, default: :false
		add_column :quizzes, :quiz_type, :integer
		add_column :quiz_instances, :remaining_time, :integer
		add_column :quiz_instances, :last_visited_at, :datetime
		add_column :quiz_instances, :paused, :boolean
	end
end
