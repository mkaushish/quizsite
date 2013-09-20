class AddClassroomProblemSetsTable < ActiveRecord::Migration
  	def up
    	create_table :classroom_problem_sets do |t|
          t.integer :classroom_id
          t.integer :problem_set_id
          t.datetime :created_at
          t.datetime :updated_at
          t.datetime :starts_at
          t.datetime :ends_at
    	end
      # add_column :classroom_problem_sets, :classroom_id, :integer
  	end

	   def down
		  drop_table :classroom_problem_sets do |t|
          t.integer :problem_set_id
         t.datetime :created_at
          t.datetime :updated_at
          t.datetime :starts_at
          t.datetime :ends_at
      end
  	end
end