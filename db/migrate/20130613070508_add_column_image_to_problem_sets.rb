class AddColumnImageToProblemSets < ActiveRecord::Migration
  def self.up
    add_column :problem_sets, :image, :string
  end
end
