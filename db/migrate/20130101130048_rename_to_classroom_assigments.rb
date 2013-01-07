class RenameToClassroomAssigments < ActiveRecord::Migration
  def change
    rename_table :class_assignments, :classroom_assignments

    rename_table :hw_assignments, :classroom_problem_sets
    rename_column :classroom_problem_sets, :homework_id, :problem_set_id
    change_table :classroom_problem_sets do |t|
      t.datetime :starts_at
      t.datetime :ends_at
    end

    create_table :classroom_quizzes do |t|
      t.references :classroom
      t.references :quiz
      t.datetime :starts_at
      t.datetime :ends_at
    end
    add_index :classroom_quizzes, [:classroom_id, :quiz_id], :unique => true,
              :name => :classroom_quizzes_dual_index
  end
end
