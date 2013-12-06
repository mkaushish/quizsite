class CreateProblems < ActiveRecord::Migration
  def change
    create_table :problems do |t|
      t.binary  :serialized_problem
      t.integer :user_id
      t.integer :problem_generator_id
      t.string  :body
      t.text	:explanation

      t.timestamps
    end
  end
end
