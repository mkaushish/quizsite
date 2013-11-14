class CreateClassroomsAndClassAssignments < ActiveRecord::Migration
    def change
        create_table :classrooms do |t|
            t.string    :name
            t.integer   :teacher_id
            t.string    :student_password
            t.string    :teacher_password

            t.timestamps
        end

        create_table :class_assignments do |t|
            t.integer :classroom_id
            t.integer :student_id

            t.timestamps
        end
        add_index :classrooms, :name, :unique => true
        add_index :classrooms, :student_password, :unique => true
        add_index :classrooms, :teacher_password, :unique => true
        add_index :class_assignments, :classroom_id
        add_index :class_assignments, :student_id
        add_index :class_assignments, [:classroom_id, :student_id], :unique => true
    end
end
