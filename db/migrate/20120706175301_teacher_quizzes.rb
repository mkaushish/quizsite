class TeacherQuizzes < ActiveRecord::Migration
  def change
    create_table :hw_assignments do |t|
      t.integer :classroom_id
      t.integer :homework_id
    end

    change_table :quizzes do |t| 
      t.string :type
    end

    add_index :quizzes, [:user_id, :name], :unique => true
  end
end
