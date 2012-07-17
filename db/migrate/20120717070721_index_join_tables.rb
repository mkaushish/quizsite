class IndexJoinTables < ActiveRecord::Migration
  def change
    add_index :hw_assignments, :classroom_id
    add_index :hw_assignments, :homework_id
    add_index :hw_assignments, [:classroom_id, :homework_id], :unique => true

    add_index :class_assignments, :classroom_id
    add_index :class_assignments, :student_id
    add_index :class_assignments, [:classroom_id, :student_id], :unique => true
  end
end
