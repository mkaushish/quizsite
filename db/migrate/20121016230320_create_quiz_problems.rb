class CreateQuizProblems < ActiveRecord::Migration
    def change
        create_table :quiz_problems do |t|
            t.references 	:quiz
            t.references 	:problem_type
            t.integer 		:count, :default => 1
            t.boolean		:partial
            t.string		:problem_category
            t.integer		:problem_id

            t.timestamps
        end
        
        add_index :quiz_problems, [:quiz_id, :problem_type_id]
    end
end
