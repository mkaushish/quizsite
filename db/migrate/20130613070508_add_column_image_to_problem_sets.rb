class AddColumnImageToProblemSets < ActiveRecord::Migration
  def change
    add_column :problem_sets, :image, :string
  end
end
