class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.integer :classroom_id
      t.integer :teacher_id
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
