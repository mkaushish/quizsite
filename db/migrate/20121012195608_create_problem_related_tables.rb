class CreateProblemRelatedTables < ActiveRecord::Migration
    def change
        create_table :problem_types do |t|
            t.string        :name
            t.text          :description
            t.string        :video_link

            t.timestamps
        end

        create_table :problem_generators do |t|
            t.string        :klass
            t.references    :problem_type

            t.timestamps
        end

        create_table :problem_stats do |t|
            t.integer       :user_id
            t.integer       :problem_type_id
            t.integer       :count, :default => 0
            t.integer       :correct, :default => 0
            t.integer       :points, null: false, default: 0
            t.integer       :points_wrong, null: false, default: 0
            t.integer       :points_right, null: false, default: 100
            t.datetime      :stop_green, null: false, default: Time.now
            t.integer       :points_required, default: 500

            t.timestamps
        end

        create_table :problem_sets do |t|
            t.string        :name
            t.references    :user, :default => nil
            t.text          :description
            t.string        :video_link

            t.timestamps
        end

        create_table :problem_set_problems do |t|
            t.references    :problem_set
            t.references    :problem_type

            t.timestamps
        end

        create_table :problem_set_instances do |t|
            t.references    :user
            t.references    :problem_set
            t.datetime      :stop_green, null: false, default: Time.now
            t.integer       :num_red, default: 0
            t.integer       :num_green, default: 0
            t.integer       :num_blue, default: 0
            t.timestamp     :last_attempted

            t.timestamps
        end
        create_table :problem_set_stats do |t|
            t.references    :problem_set_instance
            t.references    :problem_type
            t.integer       :points
            t.timestamp     :last_attempted   
            t.integer       :problem_stat_id
            t.integer       :current_problem_id
            t.integer       :modifier, null: false, default: 0

            t.timestamps
        end
        
        add_index :problem_types, :name, :unique => true
        add_index :problem_stats, [ :user_id, :problem_type_id ], :unique => true, :name => :problem_stats_user_problem_type
        add_index :problem_set_problems, [:problem_set_id, :problem_type_id], :unique=> true, :name => :problem_set_problems_problem_set_problem_type
        add_index :problem_set_instances, [:user_id, :problem_set_id], :unique => true, :name => :problem_set_instances_user_problem_set
    end
end