class AddStudentsColumnToQuizzes < ActiveRecord::Migration
  def change
    add_column :quizzes, :students, :string
  end
end
