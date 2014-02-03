class AddColumnsStartTimeEndTimeLimitTimerToQuizzes < ActiveRecord::Migration
  def change
    add_column :quizzes, :start_time, :datetime
    add_column :quizzes, :end_time, :datetime
    add_column :quizzes, :limit, :integer
    add_column :quizzes, :timer, :time
  end
end
