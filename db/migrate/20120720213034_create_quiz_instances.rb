class CreateQuizInstances < ActiveRecord::Migration
    def change
        create_table :quiz_instances do |t|
            t.integer   :quiz_id
            t.integer   :user_id
            t.timestamp :last_attempted
            t.datetime  :started_at
            t.datetime  :ended_at
            t.boolean   :complete, default: nil
            t.integer   :problem_set_instance_id

            t.timestamps
        end
        add_index :quiz_instances, :quiz_id
        add_index :quiz_instances, :user_id
        add_index :quiz_instances, [:quiz_id, :user_id], :unique => true
    end
end
