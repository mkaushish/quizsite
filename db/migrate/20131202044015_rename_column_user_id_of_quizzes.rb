class RenameColumnUserIdOfQuizzes < ActiveRecord::Migration
  def self.up
	rename_column :quizzes, :user_id, :teacher_id
  end

  def self.down
	rename_column :quizzes, :teacher_id, :user_id
  end
end
