class CreateClassrooms < ActiveRecord::Migration
  def change
    create_table :classrooms do |t|
      t.string  :name
      t.integer :teacher_id
      t.timestamps
    end

    create_table :class_assignments do |t|
      t.integer :classroom_id
      t.integer :student_id
    end
  end
end
