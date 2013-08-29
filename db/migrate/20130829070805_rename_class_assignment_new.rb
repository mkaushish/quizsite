class RenameClassAssignmentNew < ActiveRecord::Migration
  def up
  	create_table :classroom_quizzes do |t|
        t.references :classroom
        t.references :quiz
    end
	add_index :classroom_quizzes, [:classroom_id, :quiz_id], :unique => true,
              :name => :classroom_quizzes_dual_index

    rename_table :class_assignments, :classroom_assignments
    rename_column :quiz_stats, :completed, :remaining
  end

  def down
  end
end
