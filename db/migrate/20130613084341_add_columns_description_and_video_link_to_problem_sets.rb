class AddColumnsDescriptionAndVideoLinkToProblemSets < ActiveRecord::Migration
  def self.up
    add_column :problem_sets, :description, :string
    add_column :problem_sets, :video_link, :string
  end
end
