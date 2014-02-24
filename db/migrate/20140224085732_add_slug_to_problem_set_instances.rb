class AddSlugToProblemSetInstances < ActiveRecord::Migration
  	def change
	    add_column :problem_set_instances, :slug, :string
	    add_index :problem_set_instances, :slug, unique: :true
  	end
end
