class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :coach_id, :null => false
      t.integer :student_id, :null => false
      t.string :relation, :null => false

      t.timestamps
    end
  end
end
