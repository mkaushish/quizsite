class AddQuizUsersTable < ActiveRecord::Migration
  def change
    create_table :quiz_users do |t|
      t.integer :quiz_id
      t.integer :user_id
      t.string :s_problem_order
      t.integer :problem_id, :default => -1
      t.integer :num_attempts, :default => 0
    end

    add_index :quiz_users, :quiz_id
    add_index :quiz_users, :user_id
    add_index :quiz_users, [:quiz_id, :user_id], :unique => true
  end
end
