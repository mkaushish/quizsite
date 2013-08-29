class RenameToClassroomAssigments < ActiveRecord::Migration
   def up
      # add_index :classroom_quizzes, [:classroom_id, :quiz_id], :unique => true,
      #         :name => :classroom_quizzes_dual_index

      # rename_table :class_assignments, :classroom_assignments
      # rename_column :quiz_stats, :completed, :remaining
  #   rename_table :hw_assignments, :classroom_problem_sets
  #   rename_column :classroom_problem_sets, :homework_id, :problem_set_id
  #   remove_column :quiz_stats, :total
   end

   # def change
  #   create_table :classroom_quizzes do |t|
  #     t.references :classroom
  #     t.references :quiz
  #     t.references :teacher

  #     t.datetime :starts_at
  #     t.datetime :ends_at
  #   end

    # add_index :classroom_quizzes, [:classroom_id, :quiz_id], :unique => true,
    #           :name => :classroom_quizzes_dual_index

    #  rename_table :class_assignments, :classroom_assignments

  #   add_column :classroom_problem_sets, :starts_at, :datetime
  #   add_column :classroom_problem_sets, :ends_at, :datetime

     # rename_column :quiz_stats, :completed, :remaining
   # end

  # def down
  #   add_column :quiz_stats, :total, :integer
  #   rename_column :classroom_problem_sets, :problem_set_id, :homework_id
  #   rename_table :classroom_problem_sets, :hw_assignments
  # end
end
