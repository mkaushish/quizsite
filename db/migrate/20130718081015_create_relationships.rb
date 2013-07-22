class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :coach_id
      t.integer :student_id
      t.string :relation

      t.timestamps
    end
  end
end
