class AddColumnOverByTimerToQuizInstances < ActiveRecord::Migration
	def change
		add_column :quiz_instances, :over_by_timer, :boolean, default: :false
		add_column :quizzes, :quiz_type, :integer
	end
end
