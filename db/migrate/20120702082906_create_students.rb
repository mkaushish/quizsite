class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.timestamps
    end

    change_table :users do |t|
      t.references :identifiable
    end

    change_table :quizzes do |t| 
      t.rename "user_id", "student_id"
    end
  end
end
