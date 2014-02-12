class RenameToClassroomAssigments < ActiveRecord::Migration
   
   def change
    create_table :classroom_quizzes do |t|
      t.references :classroom
      t.references :quiz
      

      t.datetime :starts_at
      t.datetime :ends_at
    end

    add_index :classroom_quizzes, [:classroom_id, :quiz_id], :unique => true,
              :name => :classroom_quizzes_dual_index

   #   rename_table :class_assignments, :classroom_assignments

   #  add_column :classroom_problem_sets, :starts_at, :datetime
   #  add_column :classroom_problem_sets, :ends_at, :datetime

   #   rename_column :quiz_stats, :completed, :remaining
   end

 
end
