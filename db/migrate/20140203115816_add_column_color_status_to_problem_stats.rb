class AddColumnColorStatusToProblemStats < ActiveRecord::Migration
  	def self.up
    	add_column :problem_stats, :color, :string, default: "yellow"

    	ProblemStat.reset_column_information
  	end

  	def self.down
  		remove_column :problem_stats, :color
  	end
end