class AddColumnsDescriptionAndVideoLinkToProblemSets < ActiveRecord::Migration
  def change
    add_column :problem_sets, :description, :string
    add_column :problem_sets, :video_link, :string
  end
end
