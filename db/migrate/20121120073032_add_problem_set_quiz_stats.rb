class AddProblemSetQuizStats < ActiveRecord::Migration
  def change
    create_table :problem_set_instances do |t|
      t.references :user
      t.references :problem_set
    end
    add_index :problem_set_instances, [:user_id, :problem_set_id], :unique => true,
              :name => :problem_set_instances_by_user

    create_table :problem_set_stats do |t|
      t.references :problem_set_instance
      t.references :problem_type
      t.integer    :points
    end

    rename_table :quiz_users, :quiz_instances
    # note that the [:user, :quiz] index already exists for quiz_users

    create_table :quiz_stats do |t|
      t.references :quiz_instance
      t.references :problem_type
      t.integer    :completed, :default => 0
      t.integer    :total
    end
  end
end
