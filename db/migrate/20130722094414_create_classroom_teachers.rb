class CreateClassroomTeachers < ActiveRecord::Migration
  def change
    create_table :classroom_teachers do |t|
      t.integer :classroom_id, :null => false
      t.integer :teacher_id, :null => false

      t.timestamps
    end
  end
end
