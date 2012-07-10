class TeacherQuizzes < ActiveRecord::Migration
  def change
    change_table :quizzes do |t|
      t.rename 'student_id', 'identifiable_id'
      t.string 'identifiable_type', :limit => 15
    end

    create_table :classrooms_homeworks, :id => false do |t|
      t.integer :classroom_id
      t.integer :homework_id
    end
  end
end
