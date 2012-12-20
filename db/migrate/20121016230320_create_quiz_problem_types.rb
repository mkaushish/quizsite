class CreateQuizProblemTypes < ActiveRecord::Migration
  def change
    create_table :problem_sets do |t|
      t.string :name
      t.references :user, :default => nil
    end

    create_table :problem_set_problems do |t|
      t.references :problem_set
      t.references :problem_type
    end
    add_index :problem_set_problems, [:problem_set_id, :problem_type_id], :unique=> true,
              :name => :problem_set_problem_types_index

    create_table :quiz_problems do |t|
      t.references :quiz
      t.references :problem_type
      t.integer :count, :default => 2
    end
    add_index :quiz_problems, [:quiz_id, :problem_type_id], :unique => true
  end
end
