class AddColumnTeacherIdToQuizzes < ActiveRecord::Migration
  def self.up
    add_column :quizzes, :teacher_id, :integer
    remove_column :quizzes, :user_id
  end
  def self.down
    add_column :quizzes, :user_id, :integer
    remove_column :quizzes, :teacher_id
  end
end
