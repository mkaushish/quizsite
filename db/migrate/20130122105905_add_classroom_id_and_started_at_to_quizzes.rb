class AddClassroomIdAndStartedAtToQuizzes < ActiveRecord::Migration
  def change
  	add_column :quizzes, :classroom_id, :integer
  	add_column :quizzes, :problem_set_id, :integer
  	add_column :quiz_instances, :started_at, :datetime
  	# TODO remove classroom_quizzes
  end
end
