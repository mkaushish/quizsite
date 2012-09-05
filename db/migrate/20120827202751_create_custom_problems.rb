class CreateCustomProblems < ActiveRecord::Migration
  def change
    create_table :custom_problems do |t|
      t.text :problem
      t.integer :user_id
      t.string :chapter
      t.string :name

      t.timestamps
    end
  end
end
